






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and lifetime_value >= 0 and lifetime_value <= 1000000000
)
 as expression


    from "saas_analytics"."main_marts"."customer_lifetime_value"
    where
        lifetime_value is not null
    
    

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







