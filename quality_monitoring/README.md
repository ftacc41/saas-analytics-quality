# Quality Monitoring

This folder contains Python scripts that monitor key SaaS metrics and data freshness by querying DuckDB.

These scripts are intended to run **after** you have:
- generated data into DuckDB (`data_generation/generate_saas_data.py`)
- built marts with dbt (`dbt run`)

## Setup

From the repo root:

```bash
. .venv/bin/activate
pip install -r quality_monitoring/requirements.txt
```

Set the DuckDB path (optional; defaults to `./data/warehouse/saas_analytics.duckdb`):

```bash
export DB_PATH=./data/warehouse/saas_analytics.duckdb
```

## Scripts

### `anomaly_detection.py`
- Detects churn spikes (vs rolling average)
- Detects large MRR drops (MoM)

Run:

```bash
python quality_monitoring/anomaly_detection.py
```

### `freshness_monitor.py`
Checks max loaded-at timestamps for raw source tables and returns:
- `0` when OK
- `1` when warn threshold exceeded
- `2` when error threshold exceeded

Run:

```bash
python quality_monitoring/freshness_monitor.py
```

### `metric_validation.py`
Cross-model logic checks (examples):
- MRR rollups match between fact + analysis
- GRR <= NRR

Run:

```bash
python quality_monitoring/metric_validation.py
```

