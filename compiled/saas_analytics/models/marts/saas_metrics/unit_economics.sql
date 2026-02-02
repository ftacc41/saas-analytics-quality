with ltv as (
    select
        as_of_month,
        customer_segment,
        arpu,
        avg_monthly_customer_churn_rate,
        expected_lifetime_months,
        lifetime_value
    from "saas_analytics"."main_marts"."customer_lifetime_value"
),

with_cac as (
    select
        as_of_month,
        customer_segment,
        arpu,
        avg_monthly_customer_churn_rate,
        expected_lifetime_months,
        lifetime_value,
        case
            when customer_segment = 'smb' then 600
            when customer_segment = 'mid-market' then 2500
            when customer_segment = 'enterprise' then 12000
            else null
        end as assumed_cac
    from ltv
),

final as (
    select
        md5(cast(coalesce(cast(as_of_month as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(customer_segment as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as segment_as_of_id,
        as_of_month,
        customer_segment,
        arpu,
        avg_monthly_customer_churn_rate,
        expected_lifetime_months,
        lifetime_value,
        assumed_cac,
        case
            when assumed_cac is null or assumed_cac = 0 then null
            else lifetime_value / assumed_cac
        end as ltv_to_cac_ratio,
        case
            when arpu is null or arpu = 0 or assumed_cac is null then null
            else assumed_cac / arpu
        end as payback_months
    from with_cac
)

select *
from final