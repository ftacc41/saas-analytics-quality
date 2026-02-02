






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and mrr_amount >= 0 and mrr_amount <= 100000
)
 as expression


    from "saas_analytics"."main_staging"."stg_subscriptions"
    

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







