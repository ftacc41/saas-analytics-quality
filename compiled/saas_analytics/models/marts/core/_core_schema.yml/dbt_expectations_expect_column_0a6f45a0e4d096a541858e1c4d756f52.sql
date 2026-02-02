






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and mrr_amount >= 0 and mrr_amount <= 1000000
)
 as expression


    from "saas_analytics"."main_marts"."fct_monthly_recurring_revenue"
    

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







