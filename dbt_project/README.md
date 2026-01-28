# dbt SaaS Analytics Project

This dbt project transforms raw SaaS subscription data into analytics-ready models.

## Overview

The project follows a four-layer architecture:
1. **Staging**: Clean and standardize source data
2. **Intermediate**: Business logic and transformations
3. **Marts**: Final analytics tables (facts & dimensions)
4. **Metrics**: Semantic layer definitions

## Setup

1. **Install dbt packages**
```bash
dbt deps
```

2. **Verify connection**
```bash
dbt debug
```

3. **Run models**
```bash
dbt run
```

4. **Run tests**
```bash
dbt test
```

5. **Generate documentation**
```bash
dbt docs generate
dbt docs serve
```

## Project Structure

```
models/
├── staging/           # stg_* models (1:1 with sources)
├── intermediate/      # int_* models (business logic)
├── marts/
│   ├── core/         # fct_*/dim_* dimensional models
│   └── saas_metrics/ # Business metric calculations
└── metrics/          # dbt semantic layer

macros/               # Custom dbt macros
tests/               # Custom tests
analyses/            # Ad-hoc analysis queries
```

## Models

### Staging Models
- `stg_customers` - Cleaned customer data
- `stg_subscriptions` - Cleaned subscription data
- `stg_plans` - Plan catalog
- `stg_payments` - Payment transactions
- `stg_usage_events` - Product usage events
- `stg_support_tickets` - Customer support data

### Intermediate Models
- `int_subscription_periods` - Subscription state changes
- `int_customer_cohorts` - Customers grouped by signup month
- `int_monthly_usage` - Aggregated usage per customer per month
- `int_customer_health_score` - Composite health metric
- `int_payment_history` - Payment success/failure patterns

### Marts - Core
- `dim_customers` - Customer dimension
- `dim_plans` - Plan dimension
- `dim_dates` - Date dimension
- `fct_subscriptions` - Subscription fact table
- `fct_monthly_recurring_revenue` - MRR fact table

### Marts - SaaS Metrics
- `mrr_analysis` - MRR trends and movement
- `churn_analysis` - Churn rates and reasons
- `cohort_retention` - Retention curves by cohort
- `customer_lifetime_value` - LTV calculations
- `unit_economics` - CAC, LTV/CAC ratio
- `net_revenue_retention` - NRR by cohort

## Macros

Custom macros for SaaS calculations:
- `calculate_mrr` - Normalize MRR across billing cycles
- `get_subscription_status` - Determine subscription status
- `cohort_retention_calc` - Calculate cohort retention

## Testing

All models have comprehensive tests:
- Primary keys: unique, not_null
- Foreign keys: relationships
- Status fields: accepted_values
- Numeric fields: range checks
- Business logic: custom tests

Run tests:
```bash
dbt test
```

Run specific test:
```bash
dbt test --select test_name
```

## Documentation

Generate and view documentation:
```bash
dbt docs generate
dbt docs serve
```

Documentation includes:
- Model descriptions
- Column descriptions
- Data lineage
- Test results
- Source freshness
