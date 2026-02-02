
    
    

with child as (
    select customer_id as from_field
    from "saas_analytics"."main_staging"."stg_support_tickets"
    where customer_id is not null
),

parent as (
    select customer_id as to_field
    from "saas_analytics"."main_staging"."stg_customers"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


