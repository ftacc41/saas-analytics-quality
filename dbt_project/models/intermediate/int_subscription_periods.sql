with subscriptions as (
    select
        subscription_id,
        customer_id,
        plan_id,
        start_date,
        end_date,
        status,
        mrr_amount,
        billing_cycle,
        amount
    from {{ ref('stg_subscriptions') }}
),

final as (
    select
        subscription_id,
        customer_id,
        plan_id,
        start_date,
        end_date,
        status,
        mrr_amount,
        billing_cycle,
        amount
    from subscriptions
)

select *
from final

