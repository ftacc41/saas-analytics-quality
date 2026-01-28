with source as (
    select *
    from {{ source('raw_saas', 'usage_events') }}
),

deduped as (
    select
        *,
        row_number() over (
            partition by event_id
            order by created_at desc nulls last
        ) as _row_num
    from source
),

final as (
    select
        cast(event_id as integer) as event_id,
        cast(customer_id as integer) as customer_id,
        cast(event_date as date) as event_date,
        lower(trim(event_type)) as event_type,
        cast(usage_quantity as integer) as usage_quantity,
        cast(created_at as timestamp) as created_at
    from deduped
    where _row_num = 1
)

select *
from final

