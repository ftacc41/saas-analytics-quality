






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and satisfaction_score >= 1 and satisfaction_score <= 5
)
 as expression


    from "saas_analytics"."main_staging"."stg_support_tickets"
    where
        satisfaction_score is not null
    
    

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







