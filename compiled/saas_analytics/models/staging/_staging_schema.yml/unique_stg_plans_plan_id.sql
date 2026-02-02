
    
    

select
    plan_id as unique_field,
    count(*) as n_records

from "saas_analytics"."main_staging"."stg_plans"
where plan_id is not null
group by plan_id
having count(*) > 1


