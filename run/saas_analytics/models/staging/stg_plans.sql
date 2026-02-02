
  
  create view "saas_analytics"."main_staging"."stg_plans__dbt_tmp" as (
    with source as (
    select *
    from "saas_analytics"."main"."plans"
),

deduped as (
    select
        *,
        row_number() over (
            partition by plan_id
            order by created_date desc nulls last
        ) as _row_num
    from source
),

final as (
    select
        cast(plan_id as integer) as plan_id,
        trim(plan_name) as plan_name,
        lower(trim(plan_tier)) as plan_tier,
        cast(base_price_monthly as double) as base_price_monthly,
        cast(base_price_annual as double) as base_price_annual,
        trim(features) as features,
        cast(max_users as integer) as max_users,
        cast(created_date as date) as created_date
    from deduped
    where _row_num = 1
)

select *
from final
  );
