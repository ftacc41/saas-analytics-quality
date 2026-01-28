with months as (
    select distinct
        date_month
    from {{ ref('dim_dates') }}
),

as_of as (
    select
        max(date_month) as as_of_month
    from months
),

recent_months as (
    select
        m.date_month
    from months m
    cross join as_of a
    where m.date_month > a.as_of_month - interval 6 month
      and m.date_month <= a.as_of_month
),

customers as (
    select
        customer_id,
        customer_segment
    from {{ ref('dim_customers') }}
),

customer_mrr as (
    select
        c.customer_id,
        c.customer_segment,
        rm.date_month,
        coalesce(f.mrr_amount, 0) as mrr_amount
    from customers c
    cross join recent_months rm
    left join {{ ref('fct_monthly_recurring_revenue') }} f
        on c.customer_id = f.customer_id
        and rm.date_month = f.date_month
),

segment_arpu as (
    select
        customer_segment,
        avg(case when mrr_amount > 0 then mrr_amount end) as arpu
    from customer_mrr
    group by 1
),

segment_churn as (
    select
        customer_segment,
        avg(customer_churn_rate) as avg_monthly_customer_churn_rate
    from {{ ref('churn_analysis') }}
    where date_month in (select date_month from recent_months)
    group by 1
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['a.as_of_month', 'coalesce(ar.customer_segment, ch.customer_segment)']) }} as segment_as_of_id,
        a.as_of_month,
        coalesce(ar.customer_segment, ch.customer_segment) as customer_segment,
        coalesce(ar.arpu, 0) as arpu,
        coalesce(ch.avg_monthly_customer_churn_rate, 0) as avg_monthly_customer_churn_rate,
        case
            when coalesce(ch.avg_monthly_customer_churn_rate, 0) = 0 then null
            else least(120, 1.0 / ch.avg_monthly_customer_churn_rate)
        end as expected_lifetime_months,
        case
            when coalesce(ch.avg_monthly_customer_churn_rate, 0) = 0 then null
            else coalesce(ar.arpu, 0) * least(120, 1.0 / ch.avg_monthly_customer_churn_rate)
        end as lifetime_value
    from as_of a
    full outer join segment_arpu ar
        on 1 = 1
    full outer join segment_churn ch
        on ar.customer_segment = ch.customer_segment
)

select *
from final

