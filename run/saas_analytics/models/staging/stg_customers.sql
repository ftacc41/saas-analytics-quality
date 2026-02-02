
  
  create view "saas_analytics"."main_staging"."stg_customers__dbt_tmp" as (
    with source as (
    select *
    from "saas_analytics"."main"."customers"
),

deduped as (
    select
        *,
        row_number() over (
            partition by customer_id
            order by updated_at desc nulls last, created_at desc nulls last
        ) as _row_num
    from source
),

final as (
    select
        cast(customer_id as integer) as customer_id,
        lower(trim(email)) as email,
        trim(company_name) as company_name,
        cast(signup_date as date) as signup_date,
        cast(end_date as date) as end_date,
        lower(trim(account_status)) as account_status,
        trim(industry) as industry,
        trim(company_size) as company_size,
        trim(country) as country,
        cast(created_at as timestamp) as created_at,
        cast(updated_at as timestamp) as updated_at
    from deduped
    where _row_num = 1
)

select *
from final
  );
