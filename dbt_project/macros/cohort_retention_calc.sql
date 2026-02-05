{% macro cohort_retention_calc(cohort_month_column, activity_month_column, customer_id_column) %}
{#
    Calculate cohort retention metrics for a given dataset.
    
    This macro generates the SQL to calculate:
    - Months since signup for each customer
    - Active customers per cohort per period
    - Retention rate (active / original cohort size)
    
    Args:
        cohort_month_column: Column containing the customer's signup/cohort month
        activity_month_column: Column containing the activity/observation month
        customer_id_column: Column containing the customer identifier
    
    Returns:
        SQL fragment for cohort retention calculations
    
    Usage:
        with cohort_data as (
            select
                customer_id,
                cohort_month,
                activity_month,
                {{ cohort_retention_calc('cohort_month', 'activity_month', 'customer_id') }}
            from {{ ref('int_customer_cohorts') }}
        )
#}

-- Calculate months since signup
{{ datediff(cohort_month_column, activity_month_column, 'month') }} as months_since_signup

{% endmacro %}


{% macro calculate_retention_rate(active_customers, cohort_size) %}
{#
    Calculate retention rate with null-safe division.
    
    Args:
        active_customers: Count of customers still active
        cohort_size: Original cohort size
    
    Returns:
        Retention rate as decimal (0-1), null if cohort_size is 0
    
    Usage:
        select
            cohort_month,
            months_since_signup,
            {{ calculate_retention_rate('active_customers', 'cohort_customers') }} as retention_rate
        from cohort_summary
#}

case
    when {{ cohort_size }} = 0 then null
    else cast({{ active_customers }} as {{ dbt.type_float() }}) / cast({{ cohort_size }} as {{ dbt.type_float() }})
end

{% endmacro %}


{% macro generate_cohort_periods(max_months=24) %}
{#
    Generate a series of month periods for cohort analysis.
    
    This is useful for ensuring all cohorts have rows for all periods,
    even if there's no activity in some periods.
    
    Args:
        max_months: Maximum number of months to generate (default 24)
    
    Returns:
        CTE with a single column 'months_since_signup' from 0 to max_months
    
    Usage:
        with periods as (
            {{ generate_cohort_periods(24) }}
        )
#}

select generate_series as months_since_signup
from generate_series(0, {{ max_months }})

{% endmacro %}
