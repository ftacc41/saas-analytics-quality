with source as (
    select *
    from "saas_analytics"."main"."support_tickets"
),

deduped as (
    select
        *,
        row_number() over (
            partition by ticket_id
            order by created_at desc nulls last
        ) as _row_num
    from source
),

final as (
    select
        cast(ticket_id as integer) as ticket_id,
        cast(customer_id as integer) as customer_id,
        cast(created_date as date) as created_date,
        cast(resolved_date as date) as resolved_date,
        lower(trim(category)) as category,
        lower(trim(priority)) as priority,
        cast(satisfaction_score as integer) as satisfaction_score,
        cast(created_at as timestamp) as created_at
    from deduped
    where _row_num = 1
)

select *
from final