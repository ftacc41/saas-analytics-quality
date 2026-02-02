
    
    

with all_values as (

    select
        priority as value_field,
        count(*) as n_records

    from "saas_analytics"."main_staging"."stg_support_tickets"
    group by priority

)

select *
from all_values
where value_field not in (
    'low','medium','high','urgent'
)


