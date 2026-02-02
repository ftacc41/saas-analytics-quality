
  
    
    

    create  table
      "saas_analytics"."main_marts"."churn_analysis__dbt_tmp"
  
    as (
      with months as (
    select distinct
        date_month
    from "saas_analytics"."main_marts"."dim_dates"
),

customers as (
    select
        customer_id,
        customer_segment
    from "saas_analytics"."main_marts"."dim_customers"
),

customer_month_spine as (
    select
        c.customer_id,
        c.customer_segment,
        m.date_month
    from customers c
    cross join months m
),

customer_mrr as (
    select
        cms.customer_id,
        cms.customer_segment,
        cms.date_month,
        coalesce(f.mrr_amount, 0) as mrr_amount
    from customer_month_spine cms
    left join "saas_analytics"."main_marts"."fct_monthly_recurring_revenue" f
        on cms.customer_id = f.customer_id
        and cms.date_month = f.date_month
),

with_prev as (
    select
        customer_id,
        customer_segment,
        date_month,
        mrr_amount,
        lag(mrr_amount) over (partition by customer_id order by date_month) as prev_mrr_amount
    from customer_mrr
),

monthly as (
    select
        date_month,
        customer_segment,
        sum(case when coalesce(prev_mrr_amount, 0) > 0 then 1 else 0 end) as starting_customers,
        sum(case when coalesce(prev_mrr_amount, 0) > 0 and mrr_amount = 0 then 1 else 0 end) as churned_customers,
        sum(coalesce(prev_mrr_amount, 0)) as starting_mrr,
        sum(case when coalesce(prev_mrr_amount, 0) > 0 and mrr_amount = 0 then coalesce(prev_mrr_amount, 0) else 0 end) as churned_mrr
    from with_prev
    group by 1, 2
),

final as (
    select
        md5(cast(coalesce(cast(customer_segment as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(date_month as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as segment_month_id,
        date_month,
        customer_segment,
        starting_customers,
        churned_customers,
        case
            when starting_customers = 0 then 0
            else churned_customers::double / starting_customers
        end as customer_churn_rate,
        starting_mrr,
        churned_mrr,
        case
            when starting_mrr = 0 then 0
            else churned_mrr / starting_mrr
        end as revenue_churn_rate
    from monthly
)

select *
from final
    );
  
  