# SaaS Analytics & Data Quality Engineering - Project Context

## 🎯 Project Overview
Building a production-grade analytics layer for a subscription-based SaaS business that demonstrates advanced analytics engineering skills. This project focuses on **depth over breadth** - showcasing mastery of data modeling, data quality, and business metrics rather than pipeline orchestration.

## 📊 Business Context
Analyzing subscription business data to deliver investor-grade SaaS metrics and ensure data reliability through comprehensive quality checks. This project simulates the analytics foundation that would support a growing SaaS company's decision-making.

**Key Business Questions:**
- How is our recurring revenue trending?
- What's our customer churn rate and why are customers leaving?
- What's the lifetime value of our customers?
- Which customer cohorts have the best retention?
- Are we growing efficiently? (Unit economics)
- How healthy is our revenue (expansion vs contraction)?

## 🗂️ Data Source

### **Synthetic SaaS Dataset (Custom Generated)**
We'll generate realistic subscription data using Python (Faker + custom logic) to create:

**Core Entities:**
- **Customers** (~10,000 records)
  - customer_id, email, company_name, signup_date, account_status, industry, company_size
  
- **Subscriptions** (~50,000 records)
  - subscription_id, customer_id, plan_id, start_date, end_date, status (active, paused, churned, upgraded, downgraded)
  - mrr_amount, billing_cycle (monthly, annual)
  
- **Plans** (~10 records)
  - plan_id, plan_name, plan_tier (starter, professional, enterprise), base_price, features
  
- **Usage Events** (~200,000 records)
  - event_id, customer_id, event_date, event_type (login, feature_usage, export, api_call)
  - usage_quantity
  
- **Payments** (~60,000 records)
  - payment_id, subscription_id, payment_date, amount, status (success, failed, refunded)
  - payment_method
  
- **Support Tickets** (~15,000 records)
  - ticket_id, customer_id, created_date, resolved_date, category, priority, satisfaction_score

**Data Characteristics:**
- Realistic subscription lifecycle: trials → paid → upgrades/downgrades → churn
- Seasonal patterns in signups and churn
- Correlation between usage and retention
- Payment failures leading to involuntary churn
- Multiple customer segments (SMB, Mid-Market, Enterprise)
- Time range: 3 years of historical data (2022-2024)

**Why Synthetic Data:**
- Full control over complexity and edge cases
- Can inject realistic business scenarios
- No privacy/compliance concerns
- Documents your data modeling thinking
- Fast to generate and iterate

## 🏗️ Technical Architecture

### Tech Stack (100% Free)
- **Data Warehouse**: DuckDB (lightweight, serverless, perfect for local dev)
- **Transformation**: dbt Core (show advanced features)
- **Data Quality**: dbt_expectations + Great Expectations
- **Data Generation**: Python (Faker, NumPy, Pandas)
- **BI/Visualization**: Looker Studio (Google Data Studio)
- **Testing**: dbt tests + pytest for custom validations
- **CI/CD**: GitHub Actions
- **Documentation**: dbt docs + custom metrics catalog
- **Version Control**: Git/GitHub

### Why These Tools?

**DuckDB over PostgreSQL:**
- Zero setup (just a file)
- Excellent SQL performance
- Works with dbt perfectly
- Can query Parquet files directly
- Easier for portfolio demos (no server needed)

**dbt Core (Advanced Features):**
- Project 1 showed basics, this shows mastery
- Custom macros for SaaS calculations
- Incremental models for large tables
- Packages: dbt_utils, dbt_expectations
- Exposures to link models to dashboards
- Semantic layer (dbt metrics)

**Looker Studio (Google Data Studio):**
- Free, cloud-based BI platform
- CSV file upload support for local development
- Easy to use drag-and-drop interface
- Perfect for portfolio projects and demos
- No server setup required

### Project Structure
```
saas-analytics-quality/
├── data_generation/
│   ├── generate_saas_data.py       # Main data generation script
│   ├── config.py                   # Generation parameters
│   ├── requirements.txt
│   └── README.md
├── data/
│   ├── raw/                        # Generated CSV/Parquet files
│   └── warehouse/                  # DuckDB database file
├── dbt_project/
│   ├── models/
│   │   ├── staging/                # stg_* models (1:1 with sources)
│   │   │   ├── stg_customers.sql
│   │   │   ├── stg_subscriptions.sql
│   │   │   ├── stg_payments.sql
│   │   │   ├── stg_usage_events.sql
│   │   │   ├── stg_support_tickets.sql
│   │   │   └── _staging_schema.yml
│   │   ├── intermediate/           # int_* models (business logic)
│   │   │   ├── int_subscription_periods.sql
│   │   │   ├── int_customer_cohorts.sql
│   │   │   ├── int_monthly_usage.sql
│   │   │   └── _intermediate_schema.yml
│   │   ├── marts/                  # Final analytics tables
│   │   │   ├── core/
│   │   │   │   ├── dim_customers.sql
│   │   │   │   ├── dim_plans.sql
│   │   │   │   ├── dim_dates.sql
│   │   │   │   ├── fct_subscriptions.sql
│   │   │   │   ├── fct_monthly_recurring_revenue.sql
│   │   │   │   └── fct_customer_lifecycle.sql
│   │   │   ├── saas_metrics/
│   │   │   │   ├── mrr_analysis.sql
│   │   │   │   ├── churn_analysis.sql
│   │   │   │   ├── cohort_retention.sql
│   │   │   │   ├── customer_lifetime_value.sql
│   │   │   │   ├── unit_economics.sql
│   │   │   │   └── _saas_metrics_schema.yml
│   │   │   └── _marts_schema.yml
│   │   └── metrics/                # dbt semantic layer
│   │       └── saas_metrics.yml
│   ├── macros/
│   │   ├── calculate_mrr.sql       # Custom SaaS calculation macros
│   │   ├── get_subscription_status.sql
│   │   └── cohort_retention_calc.sql
│   ├── tests/
│   │   ├── generic/                # Custom generic tests
│   │   └── singular/               # One-off business logic tests
│   ├── analyses/
│   │   └── data_profiling.sql      # Ad-hoc analysis queries
│   ├── dbt_project.yml
│   ├── packages.yml                # dbt_utils, dbt_expectations
│   └── README.md
├── quality_monitoring/
│   ├── anomaly_detection.py        # Detect metric anomalies
│   ├── freshness_monitor.py        # Check data freshness
│   ├── metric_validation.py        # Business rule validation
│   ├── requirements.txt
│   └── README.md
├── dashboards/
│   ├── DASHBOARD_BUILDING_GUIDE.md # Step-by-step visualization guide
│   ├── README.md                   # Dashboard documentation
│   ├── lookml/                     # LookML view files (optional)
│   │   └── views/
│   │       └── churn_analysis.view.lkml
│   ├── scripts/                    # CSV export scripts (gitignored)
│   ├── data/                       # Exported CSV files (gitignored)
│   └── screenshots/                # Dashboard screenshots for portfolio
├── docs/
│   ├── architecture_diagram.png
│   ├── erd_diagram.png            # Entity relationship diagram
│   ├── data_lineage.png           # From dbt docs
│   ├── metrics_catalog.md         # Business metric definitions
│   └── data_quality_report.md     # Test coverage summary
├── .github/
│   └── workflows/
│       ├── dbt_tests.yml          # Run tests on PR
│       └── deploy_docs.yml        # Deploy dbt docs to GH Pages
├── .gitignore
├── docker-compose.yml              # Optional: for local database if needed
├── README.md
└── project_context.md              # This file
```

## 📐 Data Modeling Approach

### Four-Layer Architecture

**Layer 1: Staging (`/models/staging/`)**
- One model per source table
- Renaming columns (e.g., `cust_id` → `customer_id`)
- Type casting
- Basic deduplication
- No business logic
- Prefix: `stg_`

**Layer 2: Intermediate (`/models/intermediate/`)**
- Business logic and transformations
- Joins between staging tables
- Complex calculations
- Still reusable components (not final output)
- Prefix: `int_`

**Layer 3: Marts (`/models/marts/`)**
- **Core**: Dimensional models (facts & dimensions)
- **SaaS Metrics**: Business metric calculations
- Optimized for BI consumption
- Comprehensive testing
- Prefix: `fct_`, `dim_`

**Layer 4: Metrics (`/models/metrics/`)**
- dbt semantic layer
- Reusable metric definitions
- Version-controlled business logic

### Key Data Models to Build

#### **Staging Models (6 models)**
1. `stg_customers` - Cleaned customer data
2. `stg_subscriptions` - Cleaned subscription data
3. `stg_plans` - Plan catalog
4. `stg_payments` - Payment transactions
5. `stg_usage_events` - Product usage events
6. `stg_support_tickets` - Customer support data

#### **Intermediate Models (5-7 models)**
1. `int_subscription_periods` - Subscription state changes over time
2. `int_customer_cohorts` - Customers grouped by signup month
3. `int_monthly_usage` - Aggregated usage per customer per month
4. `int_customer_health_score` - Composite health metric
5. `int_payment_history` - Payment success/failure patterns

#### **Marts - Core Models (4 models)**
1. `dim_customers` - Customer dimension with attributes
2. `dim_plans` - Plan dimension
3. `dim_dates` - Date dimension for time-series analysis
4. `fct_subscriptions` - Subscription fact table
5. `fct_monthly_recurring_revenue` - MRR fact table (one row per customer per month)

#### **Marts - SaaS Metrics (6 models)**
1. `mrr_analysis` - MRR trends, new/expansion/contraction/churn
2. `churn_analysis` - Customer churn, revenue churn, churn reasons
3. `cohort_retention` - Retention curves by signup cohort
4. `customer_lifetime_value` - LTV calculations by segment
5. `unit_economics` - CAC, LTV/CAC ratio, payback period
6. `net_revenue_retention` - NRR by cohort and segment

### Core SaaS Metrics to Calculate

**Revenue Metrics:**
- **MRR** (Monthly Recurring Revenue)
- **ARR** (Annual Recurring Revenue)
- **MRR Movement**: New, Expansion, Contraction, Churned MRR
- **Net New MRR** = New + Expansion - Contraction - Churned

**Customer Metrics:**
- **Customer Churn Rate** = Churned Customers / Total Customers
- **Revenue Churn Rate** = Churned MRR / Starting MRR
- **ARPU** (Average Revenue Per User)
- **ARPA** (Average Revenue Per Account)

**Growth Metrics:**
- **Quick Ratio** = (New MRR + Expansion MRR) / (Contraction MRR + Churned MRR)
- **Net Revenue Retention (NRR)** = (Starting MRR + Expansion - Contraction - Churn) / Starting MRR
- **Gross Revenue Retention (GRR)** = (Starting MRR - Contraction - Churn) / Starting MRR

**Lifetime Value:**
- **LTV** (Customer Lifetime Value) = ARPU / Churn Rate
- **LTV/CAC Ratio** (if including acquisition costs)

**Cohort Analysis:**
- Month-over-month retention by signup cohort
- Cohort revenue retention
- Time to first value by cohort

## ✅ Data Quality Strategy

### Testing Philosophy
- **Every model has tests** - no exceptions
- **95%+ test coverage** on marts layer
- **Fail builds on test failures** - quality gates in CI/CD
- **Business logic tests** - not just technical constraints

### Test Categories

#### **Tier 1: dbt Built-in Tests**
```yaml
# In schema.yml
columns:
  - name: customer_id
    tests:
      - unique
      - not_null
  - name: subscription_status
    tests:
      - accepted_values:
          values: ['active', 'paused', 'churned', 'trial']
  - name: plan_id
    tests:
      - relationships:
          to: ref('dim_plans')
          field: plan_id
```

#### **Tier 2: dbt_expectations Tests**
```yaml
columns:
  - name: mrr_amount
    tests:
      - dbt_expectations.expect_column_values_to_be_between:
          min_value: 0
          max_value: 100000
      - dbt_expectations.expect_column_values_to_not_be_null
  
  - name: email
    tests:
      - dbt_expectations.expect_column_values_to_match_regex:
          regex: "^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\\.[a-zA-Z0-9-.]+$"
  
  - name: churn_rate
    tests:
      - dbt_expectations.expect_column_values_to_be_between:
          min_value: 0
          max_value: 1
```

#### **Tier 3: Custom Generic Tests**
Create reusable tests for SaaS-specific logic:

```sql
-- tests/generic/subscription_dates_valid.sql
{% test subscription_dates_valid(model, column_name) %}

select *
from {{ model }}
where {{ column_name }} > end_date
   or end_date < start_date

{% endtest %}
```

#### **Tier 4: Singular Business Logic Tests**
```sql
-- tests/singular/mrr_never_decreases_more_than_20_pct.sql
with monthly_mrr as (
    select 
        date_trunc('month', date) as month,
        sum(mrr_amount) as total_mrr
    from {{ ref('fct_monthly_recurring_revenue') }}
    group by 1
),
mrr_changes as (
    select
        month,
        total_mrr,
        lag(total_mrr) over (order by month) as prev_mrr,
        case 
            when lag(total_mrr) over (order by month) = 0 then 0
            else (total_mrr - lag(total_mrr) over (order by month)) / lag(total_mrr) over (order by month)
        end as pct_change
    from monthly_mrr
)
select * from mrr_changes
where pct_change < -0.20  -- Fail if MRR drops >20% MoM
```

#### **Tier 5: Source Freshness**
```yaml
# In sources.yml
sources:
  - name: raw_saas
    database: warehouse
    freshness:
      warn_after: {count: 24, period: hour}
      error_after: {count: 48, period: hour}
    tables:
      - name: subscriptions
        loaded_at_field: updated_at
```

### Test Coverage Goals
- **Staging models**: 100% primary key tests
- **Intermediate models**: 80%+ column tests
- **Marts models**: 95%+ comprehensive tests
- **Critical metrics**: Custom business logic tests

## 🔍 Advanced dbt Features to Demonstrate

### 1. Custom Macros
```sql
-- macros/calculate_mrr.sql
{% macro calculate_mrr(amount, billing_cycle) %}
    case 
        when {{ billing_cycle }} = 'annual' then {{ amount }} / 12.0
        when {{ billing_cycle }} = 'monthly' then {{ amount }}
        else 0
    end
{% endmacro %}
```

### 2. Incremental Models
```sql
-- models/marts/fct_monthly_recurring_revenue.sql
{{ config(
    materialized='incremental',
    unique_key='customer_month_id',
    on_schema_change='fail'
) }}

select
    {{ dbt_utils.generate_surrogate_key(['customer_id', 'date_month']) }} as customer_month_id,
    customer_id,
    date_month,
    mrr_amount,
    subscription_status
from {{ ref('int_subscription_periods') }}

{% if is_incremental() %}
    where date_month > (select max(date_month) from {{ this }})
{% endif %}
```

### 3. dbt Packages
```yaml
# packages.yml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.1.1
  - package: calogica/dbt_expectations
    version: 0.10.0
```

### 4. Exposures (Link to Dashboards)
```yaml
# models/exposures.yml
exposures:
  - name: executive_dashboard
    type: dashboard
    maturity: high
    url: https://yourusername.github.io/saas-analytics/
    description: Executive summary of key SaaS metrics
    
    depends_on:
      - ref('mrr_analysis')
      - ref('churn_analysis')
      - ref('cohort_retention')
    
    owner:
      name: Your Name
      email: your.email@example.com
```

### 5. dbt Metrics (Semantic Layer)
```yaml
# models/metrics/saas_metrics.yml
metrics:
  - name: monthly_recurring_revenue
    label: Monthly Recurring Revenue
    model: ref('fct_monthly_recurring_revenue')
    description: "Sum of all active subscription MRR"
    
    calculation_method: sum
    expression: mrr_amount
    
    timestamp: date_month
    time_grains: [day, week, month, quarter, year]
    
    dimensions:
      - plan_tier
      - customer_segment
      - subscription_status
    
    filters:
      - field: subscription_status
        operator: '='
        value: "'active'"
```

## 📊 Dashboard Requirements

### Dashboard 1: Executive Summary
**KPIs:**
- Current MRR, MoM growth %
- Customer count, new customers this month
- Churn rate (customer & revenue)
- Quick Ratio

**Visualizations:**
- MRR trend (line chart, 12 months)
- MRR waterfall (new, expansion, contraction, churn)
- Top 5 plans by revenue
- Geographic distribution (if applicable)

### Dashboard 2: MRR Deep Dive
**Visualizations:**
- MRR by plan tier (stacked area chart)
- MRR movement breakdown (bar chart)
- New vs Expansion MRR (comparison)
- MRR by customer segment
- Forecast vs actual MRR

### Dashboard 3: Churn Analysis
**Visualizations:**
- Churn rate trend (customer & revenue)
- Churn reasons breakdown
- Churn by plan tier
- Involuntary vs voluntary churn
- Correlation: usage vs churn
- Time to churn distribution

### Dashboard 4: Cohort Retention
**Visualizations:**
- Cohort retention heatmap (signup month vs months retained)
- Retention curves by cohort
- Best/worst performing cohorts
- Revenue retention by cohort

### Dashboard 5: Unit Economics
**Visualizations:**
- LTV by customer segment
- LTV trends over time
- LTV/CAC ratio (if including CAC)
- Payback period distribution
- ARPU by segment

## 🚨 Anomaly Detection & Monitoring

### Python Monitoring Scripts

**1. Metric Anomaly Detection** (`quality_monitoring/anomaly_detection.py`)
```python
"""
Detect anomalies in key SaaS metrics using statistical methods.
Alerts when metrics deviate significantly from historical patterns.
"""

import duckdb
import pandas as pd
from scipy import stats

def detect_mrr_anomalies(threshold_z=2.5):
    """
    Detect MRR anomalies using Z-score method.
    Flag days where MRR is >2.5 standard deviations from mean.
    """
    # Implementation here
    pass

def detect_churn_spikes(lookback_days=30):
    """
    Flag if churn rate is 2x higher than rolling 30-day average.
    """
    # Implementation here
    pass
```

**2. Data Freshness Monitoring** (`quality_monitoring/freshness_monitor.py`)
```python
"""
Monitor data freshness and alert if data is stale.
Checks when tables were last updated.
"""

def check_data_freshness():
    """
    Check if data is fresh enough for reporting.
    Alert if subscriptions table hasn't updated in 24 hours.
    """
    # Implementation here
    pass
```

**3. Business Rule Validation** (`quality_monitoring/metric_validation.py`)
```python
"""
Validate business rules that dbt tests can't easily express.
"""

def validate_mrr_logic():
    """
    Ensure MRR calculations match expected business rules:
    - MRR should equal sum of all active subscription MRR
    - Annual plans should be divided by 12
    - Paused subscriptions should have 0 MRR
    """
    # Implementation here
    pass
```

### Alerts to Implement
- MRR drops >15% week-over-week
- Churn rate >2x rolling 30-day average
- No new subscriptions in 24 hours (data issue?)
- Payment failure rate >10%
- Data freshness: subscriptions not updated in 24h
- Test failures in dbt runs

## 🚀 Development Phases

### Phase 1: Foundation (Week 1)
**Goals:** Set up infrastructure and generate data

- [ ] Set up project structure
- [ ] Install dependencies (dbt, DuckDB, Python libraries)
- [ ] Write data generation script
- [ ] Generate synthetic SaaS data (10k customers, 50k subscriptions)
- [ ] Load data into DuckDB
- [ ] Initialize dbt project
- [ ] Configure dbt sources
- [ ] Write comprehensive README

**Deliverables:**
- Working data generation script
- DuckDB with populated tables
- Initialized dbt project
- Project README with setup instructions

### Phase 2: Staging & Intermediate Layers (Week 2)
**Goals:** Build foundational data models

- [ ] Build all 6 staging models
- [ ] Add schema.yml with descriptions and basic tests
- [ ] Build intermediate models:
  - [ ] int_subscription_periods
  - [ ] int_customer_cohorts
  - [ ] int_monthly_usage
  - [ ] int_customer_health_score
  - [ ] int_payment_history
- [ ] Add tests to intermediate models (80%+ coverage)
- [ ] Run dbt and verify models build successfully

**Deliverables:**
- 6 staging models with tests
- 5 intermediate models with tests
- All tests passing (`dbt test`)

### Phase 3: Marts & Metrics (Week 3)
**Goals:** Build final analytics layer with SaaS metrics

- [ ] Build dimensional models:
  - [ ] dim_customers
  - [ ] dim_plans
  - [ ] dim_dates
  - [ ] fct_subscriptions
  - [ ] fct_monthly_recurring_revenue
- [ ] Build SaaS metric models:
  - [ ] mrr_analysis
  - [ ] churn_analysis
  - [ ] cohort_retention
  - [ ] customer_lifetime_value
  - [ ] unit_economics
  - [ ] net_revenue_retention
- [ ] Add comprehensive tests (95%+ coverage on marts)
- [ ] Create custom macros for SaaS calculations
- [ ] Write custom dbt tests for business logic
- [ ] Create dbt metrics definitions

**Deliverables:**
- Complete marts layer (11 models)
- Custom dbt macros
- 95%+ test coverage
- dbt metrics semantic layer

### Phase 4: Data Quality & Monitoring (Week 4)
**Goals:** Implement advanced quality checks and monitoring

- [ ] Install dbt_expectations package
- [ ] Add statistical tests to key metrics
- [ ] Write Python anomaly detection scripts
- [ ] Implement freshness monitoring
- [ ] Create business rule validation
- [ ] Set up GitHub Actions for CI/CD
- [ ] Generate dbt documentation
- [ ] Deploy dbt docs to GitHub Pages

**Deliverables:**
- dbt_expectations tests on all critical metrics
- 3 Python monitoring scripts
- CI/CD pipeline running dbt tests
- Published dbt documentation site

### Phase 5: Visualization & Documentation (Week 5)
**Goals:** Build dashboards and polish documentation

- [ ] Export CSVs for Looker Studio upload
- [ ] Upload CSVs to Looker Studio
- [ ] Build 5 core dashboards
- [ ] Take high-quality screenshots
- [ ] Create architecture diagram
- [ ] Create ERD diagram
- [ ] Write metrics catalog (business definitions)
- [ ] Write data quality report
- [ ] Polish main README with:
  - [ ] Project overview
  - [ ] Setup instructions
  - [ ] Architecture overview
  - [ ] Key metrics explained
  - [ ] Dashboard screenshots
  - [ ] Link to dbt docs

**Deliverables:**
- 5 production-quality dashboards
- Complete documentation suite
- Portfolio-ready README
- All diagrams and screenshots

## 📝 Portfolio Deliverables Checklist

### GitHub Repository Must Include:

**Code:**
- [ ] Clean, well-commented Python scripts
- [ ] dbt models with comprehensive tests
- [ ] Custom dbt macros
- [ ] Quality monitoring scripts
- [ ] Requirements files (pinned versions)

**Documentation:**
- [ ] README.md with clear setup instructions
- [ ] project_context.md (this file)
- [ ] Architecture diagram
- [ ] ERD diagram
- [ ] Metrics catalog (business definitions)
- [ ] Data quality report

**dbt Documentation:**
- [ ] Published dbt docs site (GitHub Pages)
- [ ] Column-level descriptions
- [ ] Model dependencies visualized
- [ ] Test coverage visible

**Dashboards:**
- [ ] 5 production-quality Looker Studio dashboards
- [ ] High-resolution screenshots
- [ ] CSV files exported and ready for upload

**CI/CD:**
- [ ] GitHub Actions workflow
- [ ] Automated dbt tests on PR
- [ ] Passing test badge in README

**Additional:**
- [ ] Data lineage diagram (from dbt docs)
- [ ] Test coverage summary
- [ ] Sample insights/findings document

## 📣 LinkedIn Post Strategy

### Post Template:

```
Built a production-grade SaaS analytics platform with comprehensive data quality monitoring 📊

🎯 The Challenge:
SaaS businesses need reliable metrics to make decisions, but poor data quality leads to mistrust in analytics. How do you build an analytics foundation that's both comprehensive and trustworthy?

💡 The Solution:
I built a complete analytics layer for a subscription business, focusing on data quality and investor-grade metrics.

📈 What I Built:

Data Models (15+ dbt models):
• 4-layer architecture: staging → intermediate → marts → metrics
• Dimensional models optimized for BI
• 8 core SaaS metrics: MRR, churn, LTV, NRR, Quick Ratio, cohort retention

Data Quality (50+ automated tests):
• dbt built-in tests for referential integrity
• Statistical tests using dbt_expectations
• Custom business logic tests
• Anomaly detection for metric spikes
• Freshness monitoring

Business Metrics Delivered:
✅ MRR trends and waterfall analysis
✅ Customer & revenue churn breakdown
✅ Cohort retention heatmaps
✅ Customer lifetime value by segment
✅ Unit economics dashboard

🛠️ Technical Approach:

• dbt Core for transformations (macros, incremental models, semantic layer)
• DuckDB for lightweight data warehousing
• Python for data generation & monitoring
• Looker Studio for cloud-based BI dashboards (CSV upload workflow)
• GitHub Actions for CI/CD
• 95%+ test coverage on analytics models

🔍 Key Technical Wins:

1. Custom dbt macros for reusable SaaS calculations
2. Incremental models for performance at scale
3. Anomaly detection catching metric spikes before they hit dashboards
4. Semantic layer (dbt metrics) for consistent metric definitions
5. Full data lineage documentation

This demonstrates how I build analytics foundations that scale - not just creating dashboards, but ensuring the data powering them is reliable, tested, and well-documented.

📂 Full code, documentation, and dbt docs site on GitHub: [link]

Looking for my next analytics engineering role where I can build reliable data foundations. Open to opportunities and connections.

#AnalyticsEngineering #DataQuality #SaaS #dbt #DataEngineering
```

**Hashtag Strategy:**
- #AnalyticsEngineering (most important)
- #DataQuality (differentiator)
- #SaaS (business domain)
- #dbt (technical skill)
- #DataEngineering (broader audience)

**Engagement Strategy:**
1. Post mid-week (Tuesday-Thursday) around 9-11am
2. Pin to your profile for maximum visibility
3. Tag dbt Labs, DuckDB, Looker Studio (they often share community projects)
4. Respond to every comment within 24 hours
5. Share in relevant LinkedIn groups (Analytics Engineering, dbt Community)

### Follow-up Posts:

**Week 2:** Technical deep dive
"Breaking down how I built the customer churn model with dbt - here's what I learned about incremental models and testing strategies..."

**Week 3:** Lessons learned
"5 mistakes I made building this SaaS analytics platform (and how I fixed them)"

**Week 4:** Behind the scenes
"The data quality framework that catches issues before they hit dashboards - a breakdown of my 50+ automated tests"

## 🎓 Learning Outcomes

By completing this project, you demonstrate:

**Analytics Engineering:**
- Advanced dbt skills (macros, packages, incremental models, semantic layer)
- Dimensional modeling (Kimball methodology)
- Data quality frameworks
- Testing strategies

**Business Acumen:**
- Understanding of SaaS metrics
- Investor-grade analytics
- Unit economics
- Cohort analysis

**Software Engineering:**
- Version control (Git)
- CI/CD pipelines
- Documentation practices
- Code reusability (macros, functions)

**Data Engineering:**
- Data generation/simulation
- Data warehousing (DuckDB)
- Performance optimization (incremental models)
- Monitoring & alerting

**Communication:**
- Technical documentation
- Business metric definitions
- Data visualization
- Stakeholder reporting

## 🔗 Key Resources

**dbt:**
- [dbt Best Practices](https://docs.getdbt.com/guides/best-practices)
- [dbt Discourse Community](https://discourse.getdbt.com/)
- [dbt_expectations Package](https://github.com/calogica/dbt-expectations)
- [dbt Metrics](https://docs.getdbt.com/docs/build/metrics)

**SaaS Metrics:**
- [SaaS Metrics 2.0 by Davi