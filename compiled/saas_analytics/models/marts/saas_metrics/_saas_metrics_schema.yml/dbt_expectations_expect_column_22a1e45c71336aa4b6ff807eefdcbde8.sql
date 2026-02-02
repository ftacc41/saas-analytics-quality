






    with grouped_expression as (
    select
        
        
    
  
( 1=1 and ltv_to_cac_ratio >= 0 and ltv_to_cac_ratio <= 1000
)
 as expression


    from "saas_analytics"."main_marts"."unit_economics"
    where
        ltv_to_cac_ratio is not null
    
    

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







