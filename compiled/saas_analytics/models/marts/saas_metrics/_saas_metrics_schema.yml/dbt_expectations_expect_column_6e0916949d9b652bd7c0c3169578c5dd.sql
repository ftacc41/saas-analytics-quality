






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and retention_rate >= 0 and retention_rate <= 1
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







