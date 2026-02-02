
    
    

with child as (
    select plan_id as from_field
    from "saas_analytics"."main_marts"."fct_subscriptions"
    where plan_id is not null
),

parent as (
    select plan_id as to_field
    from "saas_analytics"."main_marts"."dim_plans"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


