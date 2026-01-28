"""
Validate business rules that dbt tests can't easily express.

These checks focus on cross-model consistency and metric logic validation.
They are intended to be run after `dbt run` builds marts tables.
"""

from __future__ import annotations

import logging
import os
from dataclasses import dataclass
from datetime import datetime
from typing import List

import duckdb
import pandas as pd

logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class ValidationResult:
    check_name: str
    run_at_utc: datetime
    failures: pd.DataFrame


def _connect(db_path: str) -> duckdb.DuckDBPyConnection:
    return duckdb.connect(db_path, read_only=True)


def validate_mrr_rollup_matches_analysis(db_path: str, tolerance: float = 0.01) -> ValidationResult:
    """
    Business rule: total MRR by month should match the mrr_analysis totals summed across segments.
    """
    run_at = datetime.utcnow()
    conn = _connect(db_path)

    query = f"""
        with mrr_fact as (
            select
                date_month,
                sum(mrr_amount) as total_mrr
            from main_marts.fct_monthly_recurring_revenue
            group by 1
        ),
        mrr_analysis as (
            select
                date_month,
                sum(total_mrr) as total_mrr
            from main_marts.mrr_analysis
            group by 1
        )
        select
            f.date_month,
            f.total_mrr as fact_total_mrr,
            a.total_mrr as analysis_total_mrr,
            abs(f.total_mrr - a.total_mrr) as abs_diff
        from mrr_fact f
        join mrr_analysis a
            on f.date_month = a.date_month
        where abs(f.total_mrr - a.total_mrr) > {tolerance}
        order by f.date_month;
    """

    df = conn.execute(query).df()
    conn.close()

    if len(df) > 0:
        logger.error("MRR rollup validation failed for %s months", len(df))
    else:
        logger.info("MRR rollup validation passed (tolerance=%.4f)", tolerance)

    return ValidationResult(check_name="mrr_rollup_matches_analysis", run_at_utc=run_at, failures=df)


def validate_grr_leq_nrr(db_path: str) -> ValidationResult:
    """
    Business rule: GRR should be <= NRR for all segment-month rows.
    """
    run_at = datetime.utcnow()
    conn = _connect(db_path)

    query = """
        select
            date_month,
            customer_segment,
            gross_revenue_retention,
            net_revenue_retention
        from main_marts.net_revenue_retention
        where gross_revenue_retention > net_revenue_retention
        order by date_month, customer_segment;
    """

    df = conn.execute(query).df()
    conn.close()

    if len(df) > 0:
        logger.error("GRR <= NRR validation failed for %s rows", len(df))
    else:
        logger.info("GRR <= NRR validation passed")

    return ValidationResult(check_name="grr_leq_nrr", run_at_utc=run_at, failures=df)


def validate_retention_rate_bounds(db_path: str) -> ValidationResult:
    """
    Business rule: retention_rate must be between 0 and 1 (redundant with tests, but kept for visibility).
    """
    run_at = datetime.utcnow()
    conn = _connect(db_path)

    query = """
        select
            cohort_month,
            customer_segment,
            months_since_signup,
            retention_rate
        from main_marts.cohort_retention
        where retention_rate < 0 or retention_rate > 1
        order by cohort_month, customer_segment, months_since_signup;
    """

    df = conn.execute(query).df()
    conn.close()

    if len(df) > 0:
        logger.error("Retention bounds validation failed for %s rows", len(df))
    else:
        logger.info("Retention bounds validation passed")

    return ValidationResult(check_name="retention_rate_bounds", run_at_utc=run_at, failures=df)


def run_all(db_path: str) -> List[ValidationResult]:
    return [
        validate_mrr_rollup_matches_analysis(db_path=db_path),
        validate_grr_leq_nrr(db_path=db_path),
        validate_retention_rate_bounds(db_path=db_path),
    ]


def main() -> int:
    logging.basicConfig(level=logging.INFO, format="%(asctime)s %(levelname)s %(name)s: %(message)s")
    db_path = os.environ.get("DB_PATH", "./data/warehouse/saas_analytics.duckdb")

    results = run_all(db_path)
    failed = [r for r in results if len(r.failures) > 0]

    if failed:
        logger.error("Metric validation failed: %s/%s checks have failures", len(failed), len(results))
        return 2
    logger.info("Metric validation passed: %s checks", len(results))
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

