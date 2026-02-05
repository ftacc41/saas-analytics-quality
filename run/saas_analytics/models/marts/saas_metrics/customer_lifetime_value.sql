
  
    
    

    create  table
      "saas_analytics"."main_marts"."customer_lifetime_value__dbt_tmp"
  
    as (
      with months as (
    select distinct
        date_month
    from "saas_analytics"."main_marts"."dim_dates"
    where date_month >= '2022-06-01'  -- Start after 6 months of data exists
),

customers as (
    select
        customer_id,
        customer_segment
    from "saas_analytics"."main_marts"."dim_customers"
),

mrr as (
    select
        customer_id,
        date_month,
        mrr_amount
    from "saas_analytics"."main_marts"."fct_monthly_recurring_revenue"
),

churn as (
    select
        date_month,
        customer_segment,
        customer_churn_rate
    from "saas_analytics"."main_marts"."churn_analysis"
),

-- For each as_of_month, calculate ARPU using trailing 6 months
segment_arpu_by_month as (
    select
        m.date_month as as_of_month,
        c.customer_segment,
        avg(case when mrr.mrr_amount > 0 then mrr.mrr_amount end) as arpu
    from months m
    cross join customers c
    left join mrr
        on c.customer_id = mrr.customer_id
        and mrr.date_month > m.date_month - interval 6 month
        and mrr.date_month <= m.date_month
    group by 1, 2
),

-- For each as_of_month, calculate avg churn using trailing 6 months
segment_churn_by_month as (
    select
        m.date_month as as_of_month,
        ch.customer_segment,
        avg(ch.customer_churn_rate) as avg_monthly_customer_churn_rate
    from months m
    join churn ch
        on ch.date_month > m.date_month - interval 6 month
        and ch.date_month <= m.date_month
    group by 1, 2
),

final as (
    select
        md5(cast(coalesce(cast(a.as_of_month as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(coalesce(a.customer_segment, ch.customer_segment) as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as segment_as_of_id,
        a.as_of_month,
        coalesce(a.customer_segment, ch.customer_segment) as customer_segment,
        coalesce(a.arpu, 0) as arpu,
        coalesce(ch.avg_monthly_customer_churn_rate, 0) as avg_monthly_customer_churn_rate,
        case
            when coalesce(ch.avg_monthly_customer_churn_rate, 0) = 0 then null
            else least(120, 1.0 / ch.avg_monthly_customer_churn_rate)
        end as expected_lifetime_months,
        case
            when coalesce(ch.avg_monthly_customer_churn_rate, 0) = 0 then null
            else coalesce(a.arpu, 0) * least(120, 1.0 / ch.avg_monthly_customer_churn_rate)
        end as lifetime_value
    from segment_arpu_by_month a
    full outer join segment_churn_by_month ch
        on a.as_of_month = ch.as_of_month
        and a.customer_segment = ch.customer_segment
    where coalesce(a.as_of_month, ch.as_of_month) is not null
)

select *
from final
    );
  
  