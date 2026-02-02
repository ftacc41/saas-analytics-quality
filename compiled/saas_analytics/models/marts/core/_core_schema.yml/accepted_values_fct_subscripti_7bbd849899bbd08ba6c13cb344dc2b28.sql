
    
    

with all_values as (

    select
        billing_cycle as value_field,
        count(*) as n_records

    from "saas_analytics"."main_marts"."fct_subscriptions"
    group by billing_cycle

)

select *
from all_values
where value_field not in (
    'monthly','annual'
)


