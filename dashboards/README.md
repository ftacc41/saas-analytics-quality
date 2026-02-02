# Looker Dashboards

This directory contains LookML models and dashboards for the 5 core SaaS analytics dashboards.

## 📊 Dashboards

1. **Executive Summary** (`executive_summary`)
   - KPIs: MRR, customers, churn, Quick Ratio
   - MRR trend (12 months)
   - MRR waterfall (new, expansion, contraction, churn)
   - Top 5 plans by revenue

2. **MRR Deep Dive** (`mrr_deep_dive`)
   - MRR by plan tier (stacked area chart)
   - MRR movement breakdown
   - New vs Expansion MRR comparison
   - MRR by customer segment

3. **Churn Analysis** (`churn_analysis`)
   - Churn rate trends (customer & revenue)
   - Churn reasons breakdown
   - Churn by plan tier
   - Time to churn distribution

4. **Cohort Retention** (`cohort_retention`)
   - Cohort retention heatmap
   - Retention curves by cohort
   - Best/worst performing cohorts
   - Revenue retention by cohort

5. **Unit Economics** (`unit_economics`)
   - LTV by customer segment
   - LTV trends over time
   - LTV/CAC ratio
   - Payback period distribution
   - ARPU by segment

## 🚀 Setup Instructions

### Prerequisites

1. **Looker Instance**
   - Access to a Looker instance (Looker Cloud or Looker-hosted)
   - Admin or Developer permissions to create LookML models
   - Alternatively, use Looker Desktop for local development

2. **DuckDB Database**
   - Ensure you've generated data and run dbt models
   - Database location: `../data/warehouse/saas_analytics.duckdb` (relative to project root)

### Connecting Looker to DuckDB

#### Option 1: Using Looker Desktop (Recommended for Local Development)

1. **Install Looker Desktop**
   - Download from: https://cloud.google.com/looker/docs/desktop
   - Install and launch Looker Desktop

2. **Set up DuckDB Connection**
   - Looker Desktop supports local database connections
   - Configure connection to your DuckDB file path

#### Option 2: Using Looker Cloud with DuckDB via ODBC/JDBC

1. **Set up DuckDB ODBC/JDBC Driver**
   - Download DuckDB ODBC or JDBC driver
   - Configure in your Looker instance's database connection settings

2. **Create Database Connection in Looker**
   - Admin → Connections → New Connection
   - Select appropriate database type (may need custom connection)
   - Enter connection details pointing to your DuckDB file

#### Option 3: Export to PostgreSQL/MySQL (Alternative)

If direct DuckDB connection isn't available:
1. Export DuckDB data to PostgreSQL or MySQL
2. Connect Looker to the PostgreSQL/MySQL instance

### Creating LookML Models

1. **Create LookML Project**
   - In Looker, go to Develop → Projects → New Project
   - Clone or create a new Git repository for your LookML models

2. **Create Model Files**
   - Create `models/saas_analytics.model.lkml`
   - Define connection and explores for each table:
     - `fct_monthly_recurring_revenue`
     - `dim_customers`
     - `dim_plans`
     - `dim_dates`
     - `fct_subscriptions`
     - `mrr_analysis`
     - `churn_analysis`
     - `cohort_retention`
     - `unit_economics`

3. **Define Explores**
   - Each explore should reference the corresponding dbt marts table
   - Add dimensions and measures as needed

4. **Build Dashboards**
   - Create Looks for each visualization
   - Combine Looks into Dashboards
   - Follow the DASHBOARD_BUILDING_GUIDE.md for specific configurations

## 📁 Directory Structure

```
dashboards/
├── README.md                    # This file
├── SETUP_GUIDE.md              # Detailed setup instructions
├── DASHBOARD_BUILDING_GUIDE.md # Step-by-step visualization guide
├── lookml/                      # LookML model files (if version controlled)
│   ├── models/
│   │   └── saas_analytics.model.lkml
│   ├── views/
│   │   ├── fct_monthly_recurring_revenue.view.lkml
│   │   ├── dim_customers.view.lkml
│   │   └── ...
│   └── dashboards/
│       ├── executive_summary.dashboard.lkml
│       └── ...
└── screenshots/                # Dashboard screenshots for portfolio
    ├── executive_summary.png
    ├── mrr_deep_dive.png
    ├── churn_analysis.png
    ├── cohort_retention.png
    └── unit_economics.png
```

## 🔄 Building Dashboards

To build these dashboards:

1. **Follow Setup Instructions** above to connect Looker to DuckDB

2. **Create LookML Models** for each table (see SETUP_GUIDE.md for details)

3. **Build Looks** for each visualization:
   - Use the DASHBOARD_BUILDING_GUIDE.md for specific configurations
   - Each visualization becomes a Look

4. **Create Dashboards**:
   - Combine Looks into Dashboards
   - Organize by dashboard theme (Executive Summary, MRR Deep Dive, etc.)

5. **Test and Refine**:
   - Verify data accuracy
   - Test filters and interactions
   - Optimize query performance

## 📸 Screenshots

Screenshots of all dashboards are available in `screenshots/` for portfolio use.

## 🔗 Resources

- [Looker Documentation](https://cloud.google.com/looker/docs)
- [LookML Reference](https://cloud.google.com/looker/docs/reference/param-lookml-reference)
- [Looker Desktop](https://cloud.google.com/looker/docs/desktop)
- [DuckDB Documentation](https://duckdb.org/docs/)
- [Connecting Looker to Databases](https://cloud.google.com/looker/docs/connecting-to-your-database)

## 📝 Notes

- **Looker Access**: You'll need access to a Looker instance. Looker Desktop is available for local development.
- **Database Path**: Use absolute paths when connecting to ensure portability.
- **Data Refresh**: Dashboards will automatically refresh based on your Looker connection settings.
- **LookML Version Control**: Consider version controlling your LookML models in Git for better collaboration and change tracking.
