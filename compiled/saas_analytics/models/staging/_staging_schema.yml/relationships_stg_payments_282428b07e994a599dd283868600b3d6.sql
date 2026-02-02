
    
    

with child as (
    select subscription_id as from_field
    from "saas_analytics"."main_staging"."stg_payments"
    where subscription_id is not null
),

parent as (
    select subscription_id as to_field
    from "saas_analytics"."main_staging"."stg_subscriptions"
)

select
    from_field

from child
left join parent
    on child.from_field = parent.to_field

where parent.to_field is null


