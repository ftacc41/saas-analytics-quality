






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and assumed_cac >= 0 and assumed_cac <= 1000000000
)
 as expression


    from "saas_analytics"."main_marts"."unit_economics"
    where
        assumed_cac is not null
    
    

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







