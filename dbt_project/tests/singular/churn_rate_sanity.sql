{#
    Business Logic Test: Customer churn rate should not exceed 50% in any month.
    
    A churn rate above 50% is extremely unusual and almost always indicates
    a data quality issue rather than actual business performance.
    
    This test will FAIL if any segment-month has a churn rate > 50%.
#}

select
    date_month,
    customer_segment,
    customer_churn_rate,
    starting_customers,
    churned_customers,
    'Churn rate exceeds 50% - likely data issue' as failure_reason
from {{ ref('churn_analysis') }}
where customer_churn_rate > 0.50
  and starting_customers > 10  -- Only flag if meaningful sample size
