
    
    

with all_values as (

    select
        plan_tier as value_field,
        count(*) as n_records

    from "saas_analytics"."main_marts"."dim_plans"
    group by plan_tier

)

select *
from all_values
where value_field not in (
    'starter','professional','enterprise'
)


