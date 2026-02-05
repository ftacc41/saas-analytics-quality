{#
    Business Logic Test: MRR should not drop more than 20% month-over-month.
    
    A drop of more than 20% in a single month is unusual for a healthy SaaS business
    and may indicate a data quality issue or a major business event that should be
    investigated.
    
    This test will FAIL if any month shows a >20% MRR decline.
#}

with monthly_mrr as (
    select
        date_month,
        sum(total_mrr) as total_mrr
    from {{ ref('mrr_analysis') }}
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
