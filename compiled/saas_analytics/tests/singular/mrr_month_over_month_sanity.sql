

with monthly_mrr as (
    select
        date_month,
        sum(total_mrr) as total_mrr
    from "saas_analytics"."main_marts"."mrr_analysis"
    group by date_month
),

mrr_changes as (
    select
        date_month,
        total_mrr,
        lag(total_mrr) over (order by date_month) as prior_month_mrr,
        case
            when lag(total_mrr) over (order by date_month) = 0 then 0
            else (total_mrr - lag(total_mrr) over (order by date_month)) 
                 / lag(total_mrr) over (order by date_month)
        end as pct_change
    from monthly_mrr
)

select
    date_month,
    total_mrr,
    prior_month_mrr,
    pct_change,
    'MRR dropped more than 20% month-over-month' as failure_reason
from mrr_changes
where pct_change < -0.20
  and prior_month_mrr > 0  -- Only flag if there was prior MRR to compare against