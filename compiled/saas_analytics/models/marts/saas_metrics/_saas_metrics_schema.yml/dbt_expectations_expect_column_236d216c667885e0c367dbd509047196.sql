






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and churned_mrr >= 0 and churned_mrr <= 1000000000
)
 as expression


    from "saas_analytics"."main_marts"."mrr_analysis"
    

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







