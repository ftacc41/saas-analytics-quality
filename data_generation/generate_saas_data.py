"""
Generate synthetic SaaS subscription data.

This script creates realistic subscription lifecycle data including:
- Customers with various segments and industries
- Subscriptions with upgrades, downgrades, and churn
- Usage events correlated with retention
- Payment transactions with realistic failure rates

Output: CSV files in /data/raw/ ready to load into DuckDB
"""

import pandas as pd
import numpy as np
from faker import Faker
from datetime import datetime, timedelta
from typing import Dict, List
import logging
import os
import sys

# Configure logging
logging.basicConfig(
    level=logging.INFO,
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s'
)
logger = logging.getLogger(__name__)

# Constants
NUM_CUSTOMERS = 10000
NUM_SUBSCRIPTIONS = 50000
NUM_PLANS = 10
NUM_USAGE_EVENTS = 200000
NUM_PAYMENTS = 60000
NUM_SUPPORT_TICKETS = 15000

START_DATE = datetime(2022, 1, 1)
END_DATE = datetime(2024, 12, 31)

# Set random seed for reproducibility
np.random.seed(42)
fake = Faker()
Faker.seed(42)


def generate_plans() -> pd.DataFrame:
    """
    Generate subscription plan catalog.
    
    Returns:
        DataFrame with plan data
        
    Business Logic:
    - 3 tiers: Starter, Professional, Enterprise
    - Pricing ranges: $29-$999/month
    - Annual plans are 20% cheaper than monthly
    """
    logger.info("Generating plan catalog...")
    
    plan_tiers = ['starter', 'professional', 'enterprise']
    plans = []
    
    plan_id = 1
    for tier in plan_tiers:
        # Multiple plans per tier
        for i in range(3 if tier == 'professional' else (2 if tier == 'starter' else 1)):
            base_price_monthly = {
                'starter': np.random.choice([29, 49, 79]),
                'professional': np.random.choice([99, 149, 199]),
                'enterprise': np.random.choice([499, 799, 999])
            }[tier]
            
            plans.append({
                'plan_id': plan_id,
                'plan_name': f"{tier.capitalize()} {i+1}" if i > 0 else tier.capitalize(),
                'plan_tier': tier,
                'base_price_monthly': base_price_monthly,
                'base_price_annual': int(base_price_monthly * 12 * 0.8),  # 20% discount
                'features': f"Features for {tier} plan",
                'max_users': {
                    'starter': np.random.choice([5, 10]),
                    'professional': np.random.choice([25, 50]),
                    'enterprise': 999
                }[tier],
                'created_date': START_DATE - timedelta(days=365)
            })
            plan_id += 1
    
    return pd.DataFrame(plans)


def generate_customers(num_customers: int) -> pd.DataFrame:
    """
    Generate customer records with realistic attributes.
    
    Args:
        num_customers: Number of customer records to generate
        
    Returns:
        DataFrame with customer data
        
    Business Logic:
    - 60% SMB, 30% Mid-Market, 10% Enterprise
    - Signup dates distributed evenly with seasonal variation
    - 5% churn rate (customers with end_date set)
    """
    logger.info(f"Generating {num_customers} customer records...")
    
    customers = []
    
    # Segment distribution
    segments = np.random.choice(
        ['SMB', 'Mid-Market', 'Enterprise'],
        size=num_customers,
        p=[0.6, 0.3, 0.1]
    )
    
    # Industry distribution
    industries = [
        'Technology', 'Healthcare', 'Finance', 'Retail', 'Education',
        'Manufacturing', 'Consulting', 'Real Estate', 'Media', 'Other'
    ]
    
    # Generate date range with seasonal variation
    date_range = (END_DATE - START_DATE).days
    seasonal_variation = np.sin(np.linspace(0, 4 * np.pi, num_customers)) * 30
    
    for i in range(num_customers):
        # Signup date with seasonal variation
        days_offset = int(i * date_range / num_customers + seasonal_variation[i])
        signup_date = START_DATE + timedelta(days=max(0, min(days_offset, date_range)))
        
        # 5% of customers have churned (end_date set)
        has_churned = np.random.random() < 0.05
        end_date = None
        if has_churned:
            churn_days = np.random.randint(30, 365)
            end_date = signup_date + timedelta(days=churn_days)
            end_date = min(end_date, END_DATE)
        
        customers.append({
            'customer_id': i + 1,
            'email': fake.email(),
            'company_name': fake.company(),
            'signup_date': signup_date,
            'end_date': end_date,
            'account_status': 'active' if not has_churned else 'churned',
            'industry': np.random.choice(industries),
            'company_size': np.random.choice(['Small', 'Medium', 'Large']) if segments[i] != 'Enterprise' else 'Large',
            'country': fake.country(),
            'created_at': signup_date,
            'updated_at': min(
                END_DATE,
                end_date if end_date else signup_date + timedelta(days=int(np.random.randint(0, 90)))
            )
        })
    
    return pd.DataFrame(customers)


def generate_subscriptions(customers_df: pd.DataFrame, plans_df: pd.DataFrame, num_subscriptions: int) -> pd.DataFrame:
    """
    Generate subscription records with lifecycle events.
    
    Args:
        customers_df: Customer DataFrame
        plans_df: Plans DataFrame
        num_subscriptions: Number of subscription records
        
    Returns:
        DataFrame with subscription data
        
    Business Logic:
    - Each customer has 1-8 subscriptions on average
    - Subscriptions can upgrade, downgrade, pause, or churn
    - MRR calculated based on billing cycle
    """
    logger.info(f"Generating {num_subscriptions} subscription records...")
    
    subscriptions = []
    subscription_id = 1
    
    # Assign subscriptions to customers (weighted towards active customers)
    active_customers = customers_df[customers_df['account_status'] == 'active']
    churned_customers = customers_df[customers_df['account_status'] == 'churned']
    
    # Active customers get more subscriptions
    customer_ids = list(active_customers['customer_id']) * 5 + list(churned_customers['customer_id'])
    np.random.shuffle(customer_ids)
    
    for i in range(num_subscriptions):
        customer_id = customer_ids[i % len(customer_ids)]
        customer = customers_df[customers_df['customer_id'] == customer_id].iloc[0]
        
        # Subscription start date (after customer signup)
        signup_date = customer['signup_date']
        max_start_offset_days = (END_DATE - signup_date).days
        if max_start_offset_days <= 0:
            start_date = signup_date
        else:
            days_after_signup = int(np.random.randint(0, max_start_offset_days))
            start_date = signup_date + timedelta(days=days_after_signup)
        
        # Select plan
        plan = plans_df.sample(1).iloc[0]
        plan_id = plan['plan_id']
        
        # Billing cycle (70% monthly, 30% annual)
        billing_cycle = np.random.choice(['monthly', 'annual'], p=[0.7, 0.3])
        base_price = plan['base_price_monthly'] if billing_cycle == 'monthly' else plan['base_price_annual']
        
        # Calculate MRR
        if billing_cycle == 'annual':
            mrr_amount = base_price / 12.0
        else:
            mrr_amount = base_price
        
        # Subscription status
        # Determine if subscription is still active
        if customer['end_date'] and start_date < customer['end_date']:
            # Customer churned, subscription should end
            end_date = customer['end_date']
            status = 'churned'
        else:
            # Subscription might still be active or have other status
            status_weights = {
                'active': 0.7,
                'paused': 0.05,
                'churned': 0.15,
                'upgraded': 0.05,
                'downgraded': 0.05
            }
            status = np.random.choice(list(status_weights.keys()), p=list(status_weights.values()))
            
            if status == 'churned':
                # Churned subscription ends before customer end_date or END_DATE
                max_end = customer['end_date'] if customer['end_date'] else END_DATE
                max_active_days = min(730, max(0, (max_end - start_date).days))
                if max_active_days <= 30:
                    end_date = max_end
                else:
                    days_active = int(np.random.randint(30, max_active_days))
                    end_date = min(start_date + timedelta(days=days_active), max_end)
            elif status in ['upgraded', 'downgraded']:
                # These subscriptions transition to new subscription
                max_active_days = min(365, max(0, (END_DATE - start_date).days))
                if max_active_days <= 60:
                    end_date = END_DATE
                else:
                    days_active = int(np.random.randint(60, max_active_days))
                    end_date = min(start_date + timedelta(days=days_active), END_DATE)
            elif status == 'paused':
                # Paused subscriptions might resume
                max_active_days = min(180, max(0, (END_DATE - start_date).days))
                if max_active_days <= 30:
                    end_date = END_DATE
                else:
                    days_active = int(np.random.randint(30, max_active_days))
                    end_date = min(start_date + timedelta(days=days_active), END_DATE)
            else:  # active
                end_date = None
        
        subscriptions.append({
            'subscription_id': subscription_id,
            'customer_id': customer_id,
            'plan_id': plan_id,
            'start_date': start_date,
            'end_date': end_date,
            'status': status,
            'mrr_amount': round(mrr_amount, 2),
            'billing_cycle': billing_cycle,
            'amount': base_price,
            'created_at': start_date,
            'updated_at': min(
                END_DATE,
                end_date if end_date else start_date + timedelta(days=int(np.random.randint(0, 30)))
            )
        })
        
        subscription_id += 1
    
    return pd.DataFrame(subscriptions)


def generate_payments(subscriptions_df: pd.DataFrame, num_payments: int) -> pd.DataFrame:
    """
    Generate payment transaction records.
    
    Args:
        subscriptions_df: Subscriptions DataFrame
        num_payments: Number of payment records
        
    Returns:
        DataFrame with payment data
        
    Business Logic:
    - Payments linked to active subscriptions
    - 5% failure rate
    - Payment dates align with billing cycles
    """
    logger.info(f"Generating {num_payments} payment records...")
    
    payments = []
    payment_id = 1
    
    # Filter to subscriptions that should have payments
    active_subscriptions = subscriptions_df[
        (subscriptions_df['status'].isin(['active', 'paused'])) |
        ((subscriptions_df['status'] == 'churned') & subscriptions_df['end_date'].notna())
    ]
    
    for i in range(num_payments):
        subscription = active_subscriptions.sample(1).iloc[0]
        
        # Payment date (within subscription period)
        start_date = subscription['start_date']
        end_date = subscription['end_date'] if pd.notna(subscription['end_date']) else END_DATE
        
        if (end_date - start_date).days < 1:
            continue
        
        payment_date = start_date + timedelta(
            days=np.random.randint(0, (end_date - start_date).days)
        )
        
        # Payment status (5% failure rate)
        status = np.random.choice(
            ['success', 'failed', 'refunded'],
            p=[0.92, 0.05, 0.03]
        )
        
        # Payment amount matches subscription amount
        amount = subscription['amount']
        if status == 'refunded':
            amount = -amount  # Negative for refunds
        
        payments.append({
            'payment_id': payment_id,
            'subscription_id': subscription['subscription_id'],
            'payment_date': payment_date,
            'amount': amount,
            'status': status,
            'payment_method': np.random.choice(['credit_card', 'bank_transfer', 'paypal']),
            'created_at': payment_date
        })
        
        payment_id += 1
    
    return pd.DataFrame(payments)


def generate_usage_events(customers_df: pd.DataFrame, num_events: int) -> pd.DataFrame:
    """
    Generate product usage event logs.
    
    Args:
        customers_df: Customers DataFrame
        num_events: Number of usage events
        
    Returns:
        DataFrame with usage event data
        
    Business Logic:
    - Events correlated with customer retention
    - Active customers have more events
    - Event types: login, feature_usage, export, api_call
    """
    logger.info(f"Generating {num_events} usage event records...")
    
    events = []
    event_id = 1
    
    # Weight events towards active customers
    active_customers = customers_df[customers_df['account_status'] == 'active']
    customer_ids = list(active_customers['customer_id']) * 3 + list(customers_df['customer_id'])
    np.random.shuffle(customer_ids)
    
    event_types = ['login', 'feature_usage', 'export', 'api_call']
    event_weights = [0.4, 0.3, 0.15, 0.15]
    
    for i in range(num_events):
        customer_id = customer_ids[i % len(customer_ids)]
        customer = customers_df[customers_df['customer_id'] == customer_id].iloc[0]
        
        # Event date (after signup, before end_date if churned)
        signup_date = customer['signup_date']
        end_date = customer['end_date'] if pd.notna(customer['end_date']) else END_DATE
        
        if (end_date - signup_date).days < 1:
            continue
        
        event_date = signup_date + timedelta(
            days=np.random.randint(0, (end_date - signup_date).days)
        )
        
        # Event type
        event_type = np.random.choice(event_types, p=event_weights)
        
        # Usage quantity (higher for active customers)
        base_quantity = 1 if event_type == 'login' else np.random.randint(1, 100)
        if customer['account_status'] == 'active':
            usage_quantity = base_quantity * np.random.randint(1, 5)
        else:
            usage_quantity = base_quantity
        
        events.append({
            'event_id': event_id,
            'customer_id': customer_id,
            'event_date': event_date,
            'event_type': event_type,
            'usage_quantity': usage_quantity,
            'created_at': event_date
        })
        
        event_id += 1
    
    return pd.DataFrame(events)


def generate_support_tickets(customers_df: pd.DataFrame, num_tickets: int) -> pd.DataFrame:
    """
    Generate customer support ticket records.
    
    Args:
        customers_df: Customers DataFrame
        num_tickets: Number of support tickets
        
    Returns:
        DataFrame with support ticket data
        
    Business Logic:
    - Tickets correlated with churn risk
    - Categories: billing, technical, feature_request, other
    - Satisfaction scores (1-5)
    """
    logger.info(f"Generating {num_tickets} support ticket records...")
    
    tickets = []
    ticket_id = 1
    
    categories = ['billing', 'technical', 'feature_request', 'other']
    priorities = ['low', 'medium', 'high', 'urgent']
    
    for i in range(num_tickets):
        customer = customers_df.sample(1).iloc[0]
        customer_id = customer['customer_id']
        
        # Ticket created date
        signup_date = customer['signup_date']
        end_date = customer['end_date'] if pd.notna(customer['end_date']) else END_DATE
        
        if (end_date - signup_date).days < 1:
            continue
        
        created_date = signup_date + timedelta(
            days=np.random.randint(0, (end_date - signup_date).days)
        )
        
        # Resolved date (80% resolved, average 3 days)
        resolved_date = None
        if np.random.random() < 0.8:
            resolution_days = np.random.exponential(3)
            resolved_date = created_date + timedelta(days=int(min(resolution_days, 30)))
            resolved_date = min(resolved_date, end_date)
        
        # Satisfaction score (1-5, weighted towards 3-4)
        satisfaction_score = np.random.choice([1, 2, 3, 4, 5], p=[0.1, 0.15, 0.3, 0.35, 0.1])
        if resolved_date is None:
            satisfaction_score = None  # Unresolved tickets have no score
        
        tickets.append({
            'ticket_id': ticket_id,
            'customer_id': customer_id,
            'created_date': created_date,
            'resolved_date': resolved_date,
            'category': np.random.choice(categories),
            'priority': np.random.choice(priorities),
            'satisfaction_score': satisfaction_score,
            'created_at': created_date
        })
        
        ticket_id += 1
    
    return pd.DataFrame(tickets)


def save_to_csv(df: pd.DataFrame, filename: str, output_dir: str = '../data/raw'):
    """Save DataFrame to CSV file."""
    os.makedirs(output_dir, exist_ok=True)
    filepath = os.path.join(output_dir, filename)
    df.to_csv(filepath, index=False)
    logger.info(f"Saved {len(df)} rows to {filepath}")


def load_to_duckdb(csv_dir: str = '../data/raw', db_path: str = '../data/warehouse/saas_analytics.duckdb'):
    """
    Load CSV files into DuckDB database.
    
    Args:
        csv_dir: Directory containing CSV files
        db_path: Path to DuckDB database file
    """
    try:
        import duckdb
        
        logger.info(f"Loading data into DuckDB at {db_path}")
        
        # Create database directory if it doesn't exist
        os.makedirs(os.path.dirname(db_path), exist_ok=True)
        
        conn = duckdb.connect(db_path)
        
        # List of tables to load
        tables = ['customers', 'subscriptions', 'plans', 'payments', 'usage_events', 'support_tickets']
        
        for table in tables:
            csv_file = os.path.join(csv_dir, f"{table}.csv")
            if os.path.exists(csv_file):
                logger.info(f"Loading {table}...")
                conn.execute(f"""
                    CREATE OR REPLACE TABLE {table} AS
                    SELECT * FROM read_csv_auto('{csv_file}')
                """)
                count = conn.execute(f"SELECT COUNT(*) FROM {table}").fetchone()[0]
                logger.info(f"  Loaded {count} rows into {table}")
            else:
                logger.warning(f"CSV file not found: {csv_file}")
        
        conn.close()
        logger.info("Data loading complete!")
        
    except ImportError:
        logger.warning("DuckDB not installed. Skipping database load. Install with: pip install duckdb")
    except Exception as e:
        logger.error(f"Error loading data into DuckDB: {e}")


def main():
    """Main function to generate all data."""
    logger.info("=" * 60)
    logger.info("Starting SaaS Data Generation")
    logger.info("=" * 60)
    
    # Generate all tables
    plans_df = generate_plans()
    customers_df = generate_customers(NUM_CUSTOMERS)
    subscriptions_df = generate_subscriptions(customers_df, plans_df, NUM_SUBSCRIPTIONS)
    payments_df = generate_payments(subscriptions_df, NUM_PAYMENTS)
    usage_events_df = generate_usage_events(customers_df, NUM_USAGE_EVENTS)
    support_tickets_df = generate_support_tickets(customers_df, NUM_SUPPORT_TICKETS)
    
    # Save to CSV
    logger.info("\nSaving data to CSV files...")
    save_to_csv(plans_df, 'plans.csv')
    save_to_csv(customers_df, 'customers.csv')
    save_to_csv(subscriptions_df, 'subscriptions.csv')
    save_to_csv(payments_df, 'payments.csv')
    save_to_csv(usage_events_df, 'usage_events.csv')
    save_to_csv(support_tickets_df, 'support_tickets.csv')
    
    # Load into DuckDB
    logger.info("\nLoading data into DuckDB...")
    load_to_duckdb()
    
    logger.info("\n" + "=" * 60)
    logger.info("Data generation complete!")
    logger.info("=" * 60)
    
    # Print summary
    logger.info("\nData Summary:")
    logger.info(f"  Customers: {len(customers_df):,}")
    logger.info(f"  Subscriptions: {len(subscriptions_df):,}")
    logger.info(f"  Plans: {len(plans_df)}")
    logger.info(f"  Payments: {len(payments_df):,}")
    logger.info(f"  Usage Events: {len(usage_events_df):,}")
    logger.info(f"  Support Tickets: {len(support_tickets_df):,}")


if __name__ == '__main__':
    main()
