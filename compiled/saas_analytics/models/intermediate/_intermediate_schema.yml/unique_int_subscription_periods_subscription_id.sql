
    
    

select
    subscription_id as unique_field,
    count(*) as n_records

from "saas_analytics"."main_intermediate"."int_subscription_periods"
where subscription_id is not null
group by subscription_id
having count(*) > 1


