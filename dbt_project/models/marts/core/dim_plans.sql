with plans as (
    select
        plan_id,
        plan_name,
        plan_tier,
        base_price_monthly,
        base_price_annual,
        features,
        max_users,
        created_date
    from {{ ref('stg_plans') }}
),

final as (
    select
        plan_id,
        plan_name,
        plan_tier,
        base_price_monthly,
        base_price_annual,
        max_users,
        features,
        created_date
    from plans
)

select *
from final

