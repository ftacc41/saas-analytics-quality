






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and amount >= 0 and amount <= 1000000
)
 as expression


    from "saas_analytics"."main_marts"."fct_subscriptions"
    

),
validation_errors as (

    select
        *
    from
        grouped_expression
    where
        not(expression = true)

)

select *
from validation_errors







