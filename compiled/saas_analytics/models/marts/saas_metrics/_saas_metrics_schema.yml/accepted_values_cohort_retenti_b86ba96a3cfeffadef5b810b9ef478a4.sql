
    
    

with all_values as (

    select
        customer_segment as value_field,
        count(*) as n_records

    from "saas_analytics"."main_marts"."cohort_retention"
    group by customer_segment

)

select *
from all_values
where value_field not in (
    'smb','mid-market','enterprise','unknown'
)


