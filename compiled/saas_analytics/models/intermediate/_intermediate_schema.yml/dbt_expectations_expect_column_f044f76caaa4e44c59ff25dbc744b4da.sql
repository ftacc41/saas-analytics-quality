






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and payment_failure_rate_last_90d >= 0 and payment_failure_rate_last_90d <= 1
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







