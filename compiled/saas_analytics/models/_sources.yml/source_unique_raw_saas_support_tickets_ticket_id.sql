
    
    

select
    ticket_id as unique_field,
    count(*) as n_records

from "saas_analytics"."main"."support_tickets"
where ticket_id is not null
group by ticket_id
having count(*) > 1


