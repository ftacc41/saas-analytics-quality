
    
    

with all_values as (

    select
        status as value_field,
        count(*) as n_records

    from "saas_analytics"."main_staging"."stg_subscriptions"
    group by status

)

select *
from all_values
where value_field not in (
    'active','paused','churned','upgraded','downgraded'
)


