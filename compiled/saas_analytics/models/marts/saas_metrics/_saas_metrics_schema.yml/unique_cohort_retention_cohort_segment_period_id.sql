
    
    

select
    cohort_segment_period_id as unique_field,
    count(*) as n_records

from "saas_analytics"."main_marts"."cohort_retention"
where cohort_segment_period_id is not null
group by cohort_segment_period_id
having count(*) > 1


