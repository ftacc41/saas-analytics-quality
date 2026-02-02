
  
  create view "saas_analytics"."main_intermediate"."int_subscription_periods__dbt_tmp" as (
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
        mrr_amount,
        billing_cycle,
        amount
    from subscriptions
)

select *
from final
  );
