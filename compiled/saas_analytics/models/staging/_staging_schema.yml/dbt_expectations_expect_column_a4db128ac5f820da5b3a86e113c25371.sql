




    with grouped_expression as (
    select
        
        
    
  


    

regexp_matches(email, '^[a-zA-Z0-9_.+-]+@[a-zA-Z0-9-]+\.[a-zA-Z0-9-.]+$', '')


 > 0
 as expression


    from "saas_analytics"."main_staging"."stg_customers"
    

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




