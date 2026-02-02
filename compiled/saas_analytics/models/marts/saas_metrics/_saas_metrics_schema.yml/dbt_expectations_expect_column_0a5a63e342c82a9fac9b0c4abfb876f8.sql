






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and expected_lifetime_months >= 0 and expected_lifetime_months <= 120
)
 as expression


    from "saas_analytics"."main_marts"."customer_lifetime_value"
    where
        expected_lifetime_months is not null
    
    

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







