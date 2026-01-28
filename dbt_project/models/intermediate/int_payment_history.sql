with payments as (
    select
        subscription_id,
        date_trunc('month', payment_date) as payment_month,
        status,
        amount
    from {{ ref('stg_payments') }}
),

monthly_payments as (
    select
        subscription_id,
        payment_month,
        count(*) as payment_count,
        sum(case when status = 'success' then 1 else 0 end) as successful_payments,
        sum(case when status = 'failed' then 1 else 0 end) as failed_payments,
        sum(case when status = 'refunded' then 1 else 0 end) as refunded_payments,
        sum(amount) as net_amount
    from payments
    group by 1, 2
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['subscription_id', 'payment_month']) }} as subscription_month_id,
        subscription_id,
        payment_month,
        payment_count,
        successful_payments,
        failed_payments,
        refunded_payments,
        net_amount
    from monthly_payments
)

select *
from final

