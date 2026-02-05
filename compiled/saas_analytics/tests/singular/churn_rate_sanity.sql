

select
    date_month,
    customer_segment,
    customer_churn_rate,
    starting_customers,
    churned_customers,
    'Churn rate exceeds 50% - likely data issue' as failure_reason
from "saas_analytics"."main_marts"."churn_analysis"
where customer_churn_rate > 0.50
  and starting_customers > 10  -- Only flag if meaningful sample size