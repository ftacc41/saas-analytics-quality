with ltv as (
    select
        as_of_month,
        customer_segment,
        arpu,
        avg_monthly_customer_churn_rate,
        expected_lifetime_months,
        lifetime_value
    from {{ ref('customer_lifetime_value') }}
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
            when customer_segment = 'smb' then {{ var('assumed_cac_smb') }}
            when customer_segment = 'mid-market' then {{ var('assumed_cac_mid_market') }}
            when customer_segment = 'enterprise' then {{ var('assumed_cac_enterprise') }}
            else null
        end as assumed_cac
    from ltv
),

final as (
    select
        {{ dbt_utils.generate_surrogate_key(['as_of_month', 'customer_segment']) }} as segment_as_of_id,
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

