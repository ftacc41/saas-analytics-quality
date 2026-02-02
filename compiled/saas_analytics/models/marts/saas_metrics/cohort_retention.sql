with months as (
    select distinct
        date_month
    from "saas_analytics"."main_marts"."dim_dates"
),

cohorts as (
    select
        c.customer_id,
        c.customer_segment,
        date_trunc('month', c.signup_date) as cohort_month
    from "saas_analytics"."main_marts"."dim_customers" c
),

cohort_sizes as (
    select
        cohort_month,
        customer_segment,
        count(*) as cohort_customers
    from cohorts
    group by 1, 2
),

customer_month_spine as (
    select
        co.customer_id,
        co.customer_segment,
        co.cohort_month,
        m.date_month
    from cohorts co
    join months m
        on m.date_month >= co.cohort_month
),

customer_mrr as (
    select
        cms.customer_id,
        cms.customer_segment,
        cms.cohort_month,
        cms.date_month,
        coalesce(f.mrr_amount, 0) as mrr_amount
    from customer_month_spine cms
    left join "saas_analytics"."main_marts"."fct_monthly_recurring_revenue" f
        on cms.customer_id = f.customer_id
        and cms.date_month = f.date_month
),

active_customers as (
    select
        cohort_month,
        customer_segment,
        date_month,
        datediff('month', cohort_month, date_month) as months_since_signup,
        count(distinct case when mrr_amount > 0 then customer_id end) as active_customers
    from customer_mrr
    group by 1, 2, 3, 4
),

final as (
    select
        md5(cast(coalesce(cast(a.customer_segment as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(a.cohort_month as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(a.months_since_signup as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as cohort_segment_period_id,
        a.cohort_month,
        a.customer_segment,
        a.months_since_signup,
        a.date_month as active_month,
        s.cohort_customers,
        a.active_customers,
        case
            when s.cohort_customers = 0 then 0
            else a.active_customers::double / s.cohort_customers
        end as retention_rate
    from active_customers a
    join cohort_sizes s
        on a.cohort_month = s.cohort_month
        and a.customer_segment = s.customer_segment
)

select *
from final