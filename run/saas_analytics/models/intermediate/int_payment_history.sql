
  
  create view "saas_analytics"."main_intermediate"."int_payment_history__dbt_tmp" as (
    with payments as (
    select
        subscription_id,
        date_trunc('month', payment_date) as payment_month,
        status,
        amount
    from "saas_analytics"."main_staging"."stg_payments"
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
        md5(cast(coalesce(cast(subscription_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(payment_month as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as subscription_month_id,
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
  );
