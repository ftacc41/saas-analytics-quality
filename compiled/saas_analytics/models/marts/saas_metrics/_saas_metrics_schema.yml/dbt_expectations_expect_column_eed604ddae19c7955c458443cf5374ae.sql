






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and payback_months >= 0 and payback_months <= 120
)
 as expression


    from "saas_analytics"."main_marts"."unit_economics"
    where
        payback_months is not null
    
    

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







