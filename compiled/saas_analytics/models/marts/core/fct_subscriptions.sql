with subscriptions as (
    select
        subscription_id,
        customer_id,
        plan_id,
        start_date,
        end_date,
        status,
        billing_cycle,
        amount,
        mrr_amount
    from "saas_analytics"."main_staging"."stg_subscriptions"
),

final as (
    select
        subscription_id,
        customer_id,
        plan_id,
        start_date,
        end_date,
        status,
        billing_cycle,
        amount,
        mrr_amount,
        case
            when status = 'active' then true
            else false
        end as is_currently_active
    from subscriptions
)

select *
from final