






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and net_revenue_retention >= 0 and net_revenue_retention <= 5
)
 as expression


    from "saas_analytics"."main_marts"."net_revenue_retention"
    

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







