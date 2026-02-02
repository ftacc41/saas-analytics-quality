






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and active_customers >= 0 and active_customers <= 1000000000
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







