






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and base_price_monthly >= 0 and base_price_monthly <= 100000
)
 as expression


    from "saas_analytics"."main_marts"."dim_plans"
    

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







