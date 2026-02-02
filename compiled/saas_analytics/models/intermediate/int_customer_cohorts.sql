with customers as (
    select
        customer_id,
        signup_date
    from "saas_analytics"."main_staging"."stg_customers"
),

final as (
    select
        customer_id,
        date_trunc('month', signup_date) as cohort_month
    from customers
)

select *
from final