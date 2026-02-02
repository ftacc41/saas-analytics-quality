






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and arpu >= 0 and arpu <= 1000000
)
 as expression


    from "saas_analytics"."main_marts"."customer_lifetime_value"
    

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







