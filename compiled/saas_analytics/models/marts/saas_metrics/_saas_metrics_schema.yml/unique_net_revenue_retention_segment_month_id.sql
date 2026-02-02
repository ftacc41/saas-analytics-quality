
    
    

select
    segment_month_id as unique_field,
    count(*) as n_records

from "saas_analytics"."main_marts"."net_revenue_retention"
where segment_month_id is not null
group by segment_month_id
having count(*) > 1


