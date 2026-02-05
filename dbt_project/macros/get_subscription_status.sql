{% macro get_subscription_status(status_column, end_date_column, current_date=none) %}
{#
    Determine the effective subscription status based on raw status and dates.
    
    This macro standardizes subscription status logic across models, handling:
    - Active subscriptions (status = 'active' and not expired)
    - Churned subscriptions (status = 'churned' or expired)
    - Trial subscriptions
    - Paused subscriptions
    
    Args:
        status_column: The column containing the raw subscription status
        end_date_column: The column containing the subscription end date
        current_date: Optional override for current date (useful for testing)
    
    Returns:
        A CASE expression that evaluates to the effective status
    
    Usage:
        select
            subscription_id,
            {{ get_subscription_status('status', 'end_date') }} as effective_status
        from {{ ref('stg_subscriptions') }}
#}

{% set today = current_date or 'current_date' %}

case
    -- Explicitly churned
    when {{ status_column }} = 'churned' then 'churned'
    
    -- Trial status
    when {{ status_column }} = 'trial' then 'trial'
    
    -- Paused status
    when {{ status_column }} = 'paused' then 'paused'
    
    -- Active but expired (implicit churn)
    when {{ status_column }} = 'active' 
         and {{ end_date_column }} is not null 
         and {{ end_date_column }} < {{ today }}
    then 'churned'
    
    -- Active and not expired
    when {{ status_column }} = 'active' then 'active'
    
    -- Fallback for any other status
    else coalesce({{ status_column }}, 'unknown')
end

{% endmacro %}
