






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and event_count >= 0 and event_count <= 100000000
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







