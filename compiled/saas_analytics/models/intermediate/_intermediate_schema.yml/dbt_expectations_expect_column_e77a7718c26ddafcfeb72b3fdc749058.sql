






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and payment_count >= 0 and payment_count <= 100000000
)
 as expression


    from "saas_analytics"."main_intermediate"."int_payment_history"
    

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







