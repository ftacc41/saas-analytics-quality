{% macro calculate_mrr(amount, billing_cycle) %}
    case
        when {{ billing_cycle }} = 'annual' then {{ amount }} / 12.0
        when {{ billing_cycle }} = 'monthly' then {{ amount }}
        else 0
    end
{% endmacro %}

