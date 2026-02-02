
    
    

select
    payment_id as unique_field,
    count(*) as n_records

from "saas_analytics"."main"."payments"
where payment_id is not null
group by payment_id
having count(*) > 1


