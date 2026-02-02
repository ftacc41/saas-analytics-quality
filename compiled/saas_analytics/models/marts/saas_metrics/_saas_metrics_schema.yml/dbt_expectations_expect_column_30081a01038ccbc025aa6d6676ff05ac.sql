






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and months_since_signup >= 0 and months_since_signup <= 120
)
 as expression


    from "saas_analytics"."main_marts"."cohort_retention"
    

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







