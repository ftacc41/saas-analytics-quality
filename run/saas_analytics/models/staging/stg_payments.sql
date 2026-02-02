
  
  create view "saas_analytics"."main_staging"."stg_payments__dbt_tmp" as (
    with source as (
    select *
    from "saas_analytics"."main"."payments"
),

deduped as (
    select
        *,
        row_number() over (
            partition by payment_id
            order by created_at desc nulls last
        ) as _row_num
    from source
),

final as (
    select
        cast(payment_id as integer) as payment_id,
        cast(subscription_id as integer) as subscription_id,
        cast(payment_date as date) as payment_date,
        cast(amount as double) as amount,
        lower(trim(status)) as status,
        lower(trim(payment_method)) as payment_method,
        cast(created_at as timestamp) as created_at
    from deduped
    where _row_num = 1
)

select *
from final
  );
