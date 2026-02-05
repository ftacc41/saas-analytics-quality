{% test mrr_non_negative(model, column_name) %}
{#
    Test that MRR values are never negative.
    Negative MRR would indicate a data quality issue.
    
    Usage in schema.yml:
    columns:
      - name: mrr_amount
        tests:
          - mrr_non_negative
#}

select
    *
from {{ model }}
where {{ column_name }} < 0

{% endtest %}
