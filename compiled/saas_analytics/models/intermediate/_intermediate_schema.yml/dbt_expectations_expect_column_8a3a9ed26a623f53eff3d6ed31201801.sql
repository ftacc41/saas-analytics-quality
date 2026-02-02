






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and health_score >= 0 and health_score <= 100
)
 as expression


    from "saas_analytics"."main_intermediate"."int_customer_health_score"
    

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







