
    
    



select payment_failure_rate_last_90d
from "saas_analytics"."main_intermediate"."int_customer_health_score"
where payment_failure_rate_last_90d is null


