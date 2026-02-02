






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and avg_monthly_customer_churn_rate >= 0 and avg_monthly_customer_churn_rate <= 1
)
 as expression


    from "saas_analytics"."main_marts"."customer_lifetime_value"
    

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







