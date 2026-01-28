with date_spine as (
    {{ dbt_utils.date_spine(
        datepart="day",
        start_date="cast('" ~ var('start_date') ~ "' as date)",
        end_date="cast('" ~ var('end_date') ~ "' as date)"
    ) }}
),

final as (
    select
        cast(date_day as date) as date_day,
        date_trunc('month', date_day) as date_month,
        extract(year from date_day) as year,
        extract(quarter from date_day) as quarter,
        extract(month from date_day) as month,
        extract(day from date_day) as day_of_month,
        extract(dow from date_day) as day_of_week,
        case when extract(dow from date_day) in (0, 6) then true else false end as is_weekend
    from date_spine
)

select *
from final

