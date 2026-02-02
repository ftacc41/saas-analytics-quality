
    
    

select
    segment_as_of_id as unique_field,
    count(*) as n_records

from "saas_analytics"."main_marts"."unit_economics"
where segment_as_of_id is not null
group by segment_as_of_id
having count(*) > 1


