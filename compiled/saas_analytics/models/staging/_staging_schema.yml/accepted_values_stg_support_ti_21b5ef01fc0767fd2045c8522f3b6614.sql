
    
    

with all_values as (

    select
        category as value_field,
        count(*) as n_records

    from "saas_analytics"."main_staging"."stg_support_tickets"
    group by category

)

select *
from all_values
where value_field not in (
    'billing','technical','feature_request','other'
)


