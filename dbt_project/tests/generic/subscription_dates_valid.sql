{% test subscription_dates_valid(model, start_column, end_column) %}
{#
    Test that subscription start dates are always before or equal to end dates.
    
    Usage in schema.yml:
    models:
      - name: fct_subscriptions
        tests:
          - subscription_dates_valid:
              start_column: start_date
              end_column: end_date
#}

select
    *
from {{ model }}
where {{ end_column }} is not null
  and {{ start_column }} > {{ end_column }}

{% endtest %}
