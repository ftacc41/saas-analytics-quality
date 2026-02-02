






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and customer_churn_rate >= 0 and customer_churn_rate <= 1
)
 as expression


    from "saas_analytics"."main_marts"."churn_analysis"
    

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







