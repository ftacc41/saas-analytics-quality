
  
  create view "saas_analytics"."main_intermediate"."int_monthly_usage__dbt_tmp" as (
    with usage_events as (
    select
        customer_id,
        date_trunc('month', event_date) as usage_month,
        event_type,
        usage_quantity
    from "saas_analytics"."main_staging"."stg_usage_events"
),

monthly_usage as (
    select
        customer_id,
        usage_month,
        count(*) as event_count,
        sum(usage_quantity) as total_usage_quantity,
        sum(case when event_type = 'login' then 1 else 0 end) as login_events,
        sum(case when event_type = 'feature_usage' then 1 else 0 end) as feature_usage_events,
        sum(case when event_type = 'export' then 1 else 0 end) as export_events,
        sum(case when event_type = 'api_call' then 1 else 0 end) as api_call_events
    from usage_events
    group by 1, 2
),

final as (
    select
        md5(cast(coalesce(cast(customer_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(usage_month as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as customer_month_id,
        customer_id,
        usage_month,
        event_count,
        total_usage_quantity,
        login_events,
        feature_usage_events,
        export_events,
        api_call_events
    from monthly_usage
)

select *
from final
  );
