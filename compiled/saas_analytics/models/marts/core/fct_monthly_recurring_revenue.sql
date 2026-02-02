with months as (
    select distinct
        date_month
    from "saas_analytics"."main_marts"."dim_dates"
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
        
    case
        when billing_cycle = 'annual' then amount / 12.0
        when billing_cycle = 'monthly' then amount
        else 0
    end
 as normalized_mrr_amount
    from "saas_analytics"."main_staging"."stg_subscriptions"
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
        md5(cast(coalesce(cast(customer_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(date_month as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as customer_month_id,
        customer_id,
        date_month,
        sum(mrr_amount) as mrr_amount,
        count(distinct subscription_id) as subscription_count
    from subscription_months
    group by 1, 2, 3
)

select *
from final