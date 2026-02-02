






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and usage_quantity >= 0 and usage_quantity <= 1000000
)
 as expression


    from "saas_analytics"."main_staging"."stg_usage_events"
    

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







