
    
    

select
    subscription_month_id as unique_field,
    count(*) as n_records

from "saas_analytics"."main_intermediate"."int_payment_history"
where subscription_month_id is not null
group by subscription_month_id
having count(*) > 1


