
  
    
    

    create  table
      "saas_analytics"."main_marts"."mrr_analysis__dbt_tmp"
  
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

customer_mrr_with_prev as (
    select
        customer_id,
        customer_segment,
        date_month,
        mrr_amount,
        lag(mrr_amount) over (partition by customer_id order by date_month) as prev_mrr_amount
    from customer_mrr
),

classified as (
    select
        customer_id,
        customer_segment,
        date_month,
        mrr_amount,
        coalesce(prev_mrr_amount, 0) as prev_mrr_amount,
        mrr_amount - coalesce(prev_mrr_amount, 0) as mrr_change,
        case
            when coalesce(prev_mrr_amount, 0) = 0 and mrr_amount > 0 then 'new'
            when coalesce(prev_mrr_amount, 0) > 0 and mrr_amount = 0 then 'churn'
            when mrr_amount > coalesce(prev_mrr_amount, 0) and coalesce(prev_mrr_amount, 0) > 0 then 'expansion'
            when mrr_amount < coalesce(prev_mrr_amount, 0) and mrr_amount > 0 then 'contraction'
            else 'no_change'
        end as mrr_movement_type
    from customer_mrr_with_prev
),

final as (
    select
        md5(cast(coalesce(cast(customer_segment as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(date_month as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as segment_month_id,
        date_month,
        customer_segment,
        sum(mrr_amount) as total_mrr,
        sum(case when mrr_movement_type = 'new' then mrr_amount else 0 end) as new_mrr,
        sum(case when mrr_movement_type = 'expansion' then mrr_change else 0 end) as expansion_mrr,
        sum(case when mrr_movement_type = 'contraction' then abs(mrr_change) else 0 end) as contraction_mrr,
        sum(case when mrr_movement_type = 'churn' then prev_mrr_amount else 0 end) as churned_mrr,
        sum(case when mrr_movement_type in ('new', 'expansion') then mrr_change else 0 end)
        - sum(case when mrr_movement_type in ('contraction', 'churn') then abs(mrr_change) else 0 end) as net_new_mrr
    from classified
    group by 1, 2, 3
)

select *
from final
    );
  
  