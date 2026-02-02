






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and total_usage_quantity >= 0 and total_usage_quantity <= 1000000000
)
 as expression


    from "saas_analytics"."main_intermediate"."int_monthly_usage"
    

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







