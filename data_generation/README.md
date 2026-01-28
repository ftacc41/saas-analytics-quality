# Data Generation

This module generates synthetic SaaS subscription data for the analytics project.

## Overview

The data generation script creates realistic subscription business data including:
- **Customers**: ~10,000 customer records with various segments and industries
- **Subscriptions**: ~50,000 subscription records with lifecycle events
- **Plans**: 10 subscription plans across 3 tiers
- **Payments**: ~60,000 payment transactions
- **Usage Events**: ~200,000 product usage events
- **Support Tickets**: ~15,000 customer support tickets

## Setup

1. Install dependencies:
```bash
pip install -r requirements.txt
```

## Usage

Run the data generation script:

```bash
python generate_saas_data.py
```

This will:
1. Generate all CSV files in `../data/raw/`
2. Load data into DuckDB at `../data/warehouse/saas_analytics.duckdb`

## Data Characteristics

### Customers
- **Segments**: 60% SMB, 30% Mid-Market, 10% Enterprise
- **Churn Rate**: 5% of customers have churned
- **Signup Dates**: Distributed across 2022-2024 with seasonal variation
- **Industries**: Technology, Healthcare, Finance, Retail, Education, etc.

### Subscriptions
- **Billing Cycles**: 70% monthly, 30% annual
- **Statuses**: active, paused, churned, upgraded, downgraded
- **MRR**: Calculated based on billing cycle (annual divided by 12)

### Payments
- **Failure Rate**: 5% of payments fail
- **Refund Rate**: 3% of payments are refunded
- **Payment Methods**: Credit card, bank transfer, PayPal

### Usage Events
- **Event Types**: login, feature_usage, export, api_call
- **Correlation**: Active customers have more usage events
- **Distribution**: Weighted towards active customers

### Support Tickets
- **Categories**: billing, technical, feature_request, other
- **Resolution Rate**: 80% of tickets are resolved
- **Satisfaction**: Scores from 1-5 (weighted towards 3-4)

## Reproducibility

The script uses fixed random seeds (42) for reproducibility. Running the script multiple times will generate the same data.

## Output Files

All CSV files are saved to `../data/raw/`:
- `customers.csv`
- `subscriptions.csv`
- `plans.csv`
- `payments.csv`
- `usage_events.csv`
- `support_tickets.csv`

The DuckDB database is created at `../data/warehouse/saas_analytics.duckdb`.
