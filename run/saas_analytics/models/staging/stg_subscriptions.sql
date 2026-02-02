
  
  create view "saas_analytics"."main_staging"."stg_subscriptions__dbt_tmp" as (
    with source as (
    select *
    from "saas_analytics"."main"."subscriptions"
),

deduped as (
    select
        *,
        row_number() over (
            partition by subscription_id
            order by updated_at desc nulls last, created_at desc nulls last
        ) as _row_num
    from source
),

final as (
    select
        cast(subscription_id as integer) as subscription_id,
        cast(customer_id as integer) as customer_id,
        cast(plan_id as integer) as plan_id,
        cast(start_date as date) as start_date,
        cast(end_date as date) as end_date,
        lower(trim(status)) as status,
        cast(mrr_amount as double) as mrr_amount,
        lower(trim(billing_cycle)) as billing_cycle,
        cast(amount as double) as amount,
        cast(created_at as timestamp) as created_at,
        cast(updated_at as timestamp) as updated_at
    from deduped
    where _row_num = 1
)

select *
from final
  );
