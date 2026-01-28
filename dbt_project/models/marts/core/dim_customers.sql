with customers as (
    select
        customer_id,
        email,
        company_name,
        industry,
        company_size,
        country,
        signup_date,
        end_date,
        account_status
    from {{ ref('stg_customers') }}
),

final as (
    select
        customer_id,
        email,
        company_name,
        industry,
        company_size,
        case
            when lower(company_size) = 'small' then 'smb'
            when lower(company_size) = 'medium' then 'mid-market'
            when lower(company_size) = 'large' then 'enterprise'
            else 'unknown'
        end as customer_segment,
        country,
        signup_date,
        end_date as churn_date,
        account_status,
        case when account_status = 'active' then true else false end as is_active
    from customers
)

select *
from final

