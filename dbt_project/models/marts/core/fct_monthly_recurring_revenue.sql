with months as (
    select distinct
        date_month
    from {{ ref('dim_dates') }}
),

subscriptions as (
    select
        subscription_id,
        customer_id,
        plan_id,
        start_date,
        end_date,
        status,
        billing_cycle,
        amount,
        -- Normalize MRR from amount + billing_cycle (more robust than trusting raw mrr_amount)
        {{ calculate_mrr('amount', 'billing_cycle') }} as normalized_mrr_amount
    from {{ ref('stg_subscriptions') }}
),

subscription_months as (
    select
        s.customer_id,
        s.subscription_id,
        s.plan_id,
        m.date_month,
        s.status,
        s.billing_cycle,
        s.amount,
        case
            when s.status = 'paused' then 0
            else s.normalized_mrr_amount
        end as mrr_amount
    from subscriptions s
    join months m
        on m.date_month >= date_trunc('month', s.start_date)
        and (
            s.end_date is null
            or m.date_month <= date_trunc('month', s.end_date)
        )
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['customer_id', 'date_month']) }} as customer_month_id,
        customer_id,
        date_month,
        sum(mrr_amount) as mrr_amount,
        count(distinct subscription_id) as subscription_count
    from subscription_months
    group by 1, 2, 3
)

select *
from final

