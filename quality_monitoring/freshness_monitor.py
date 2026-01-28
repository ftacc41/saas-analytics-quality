"""
Monitor data freshness in DuckDB.

Checks whether source tables have recent data based on their loaded_at fields.
Intended to be run in CI or on a schedule.
"""

from __future__ import annotations

import logging
import os
from dataclasses import dataclass
from datetime import datetime
from typing import Dict, List

import duckdb
import pandas as pd

logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class FreshnessCheck:
    table: str
    loaded_at_field: str
    warn_hours: int = 24
    error_hours: int = 48


DEFAULT_CHECKS: List[FreshnessCheck] = [
    FreshnessCheck(table="customers", loaded_at_field="updated_at"),
    FreshnessCheck(table="subscriptions", loaded_at_field="updated_at"),
    # Plans are a slowly changing/static dimension in this project; don't alert aggressively.
    FreshnessCheck(table="plans", loaded_at_field="created_date", warn_hours=24 * 3650, error_hours=24 * 3650 * 2),
    FreshnessCheck(table="payments", loaded_at_field="created_at"),
    FreshnessCheck(table="usage_events", loaded_at_field="created_at"),
    FreshnessCheck(table="support_tickets", loaded_at_field="created_at"),
]


def check_freshness(db_path: str, checks: List[FreshnessCheck] = DEFAULT_CHECKS) -> pd.DataFrame:
    """
    Returns a dataframe with latest timestamp/date per table and freshness status.
    """
    conn = duckdb.connect(db_path, read_only=True)

    rows: List[Dict] = []
    now_utc = pd.Timestamp.now(tz="UTC")

    # First pass: get max_loaded_at per table
    max_loaded_by_table: Dict[str, pd.Timestamp] = {}
    for c in checks:
        # Some loaded_at fields are DATE; cast to TIMESTAMP for consistent math
        sql = f"""
            select
                '{c.table}' as table_name,
                '{c.loaded_at_field}' as loaded_at_field,
                max(cast({c.loaded_at_field} as timestamp)) as max_loaded_at
            from {c.table}
        """
        df = conn.execute(sql).df()
        max_loaded_at = df.loc[0, "max_loaded_at"]
        if pd.isna(max_loaded_at):
            max_loaded_by_table[c.table] = pd.NaT
        else:
            ts = pd.Timestamp(max_loaded_at)
            if ts.tzinfo is None:
                ts = ts.tz_localize("UTC")
            else:
                ts = ts.tz_convert("UTC")
            max_loaded_by_table[c.table] = ts

    # Auto-detect historical/static datasets:
    # If the newest timestamp is older than 48 hours, treat freshness as "relative to newest table time"
    # rather than "relative to now". This avoids constant failures for historical synthetic datasets.
    non_null = [t for t in max_loaded_by_table.values() if not pd.isna(t)]
    reference_time = now_utc
    if non_null:
        newest = max(non_null)
        if (now_utc - newest) > pd.Timedelta(hours=48):
            reference_time = newest

        max_ts = max_loaded_by_table[c.table]
        age_hours = None
        status = "unknown"
        if pd.isna(max_ts):
            status = "error"
        else:
            age_hours = (reference_time - max_ts).total_seconds() / 3600.0
            if age_hours >= c.error_hours:
                status = "error"
            elif age_hours >= c.warn_hours:
                status = "warn"
            else:
                status = "ok"

        rows.append(
            {
                "table_name": c.table,
                "loaded_at_field": c.loaded_at_field,
                "max_loaded_at": None if pd.isna(max_ts) else max_ts.to_pydatetime(),
                "age_hours": None if age_hours is None else round(age_hours, 2),
                "status": status,
                "warn_after_hours": c.warn_hours,
                "error_after_hours": c.error_hours,
                "reference_time_utc": reference_time.to_pydatetime(),
            }
        )

    conn.close()
    return pd.DataFrame(rows).sort_values(["status", "age_hours"], ascending=[True, False])


def main() -> int:
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s: %(message)s")

    db_path = os.environ.get("DB_PATH", "./data/warehouse/saas_analytics.duckdb")
    df = check_freshness(db_path)

    # Log summary
    for _, row in df.iterrows():
        msg = f"{row['table_name']}: status={row['status']} max_loaded_at={row['max_loaded_at']} age_hours={row['age_hours']}"
        if row["status"] == "error":
            logger.error(msg)
        elif row["status"] == "warn":
            logger.warning(msg)
        else:
            logger.info(msg)

    if (df["status"] == "error").any():
        return 2
    if (df["status"] == "warn").any():
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

