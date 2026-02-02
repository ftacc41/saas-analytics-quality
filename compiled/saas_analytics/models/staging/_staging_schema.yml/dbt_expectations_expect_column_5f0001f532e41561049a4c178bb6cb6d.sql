






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and base_price_annual >= 0 and base_price_annual <= 1000000
)
 as expression


    from "saas_analytics"."main_staging"."stg_plans"
    

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







