
    
    

select
    customer_id as unique_field,
    count(*) as n_records

from "saas_analytics"."main_intermediate"."int_customer_cohorts"
where customer_id is not null
group by customer_id
having count(*) > 1


