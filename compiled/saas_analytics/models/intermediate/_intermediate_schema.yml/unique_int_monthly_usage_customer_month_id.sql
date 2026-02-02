
    
    

select
    customer_month_id as unique_field,
    count(*) as n_records

from "saas_analytics"."main_intermediate"."int_monthly_usage"
where customer_month_id is not null
group by customer_month_id
having count(*) > 1


