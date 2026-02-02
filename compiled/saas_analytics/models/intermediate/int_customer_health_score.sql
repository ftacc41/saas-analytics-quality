with customers as (
    select
        customer_id
    from "saas_analytics"."main_staging"."stg_customers"
),

as_of as (
    select
        greatest(
            coalesce((select max(event_date) from "saas_analytics"."main_staging"."stg_usage_events"), date '1900-01-01'),
            coalesce((select max(payment_date) from "saas_analytics"."main_staging"."stg_payments"), date '1900-01-01'),
            coalesce((select max(created_date) from "saas_analytics"."main_staging"."stg_support_tickets"), date '1900-01-01')
        ) as as_of_date
),

usage_last_30d as (
    select
        ue.customer_id,
        count(*) as events_last_30d,
        sum(ue.usage_quantity) as usage_quantity_last_30d
    from "saas_analytics"."main_staging"."stg_usage_events" ue
    cross join as_of a
    where ue.event_date > a.as_of_date - interval 30 day
      and ue.event_date <= a.as_of_date
    group by 1
),

tickets_last_90d as (
    select
        t.customer_id,
        count(*) as tickets_created_last_90d,
        sum(case when t.resolved_date is null then 1 else 0 end) as open_tickets
    from "saas_analytics"."main_staging"."stg_support_tickets" t
    cross join as_of a
    where t.created_date > a.as_of_date - interval 90 day
      and t.created_date <= a.as_of_date
    group by 1
),

payment_failures_last_90d as (
    select
        s.customer_id,
        count(*) as payment_events_last_90d,
        sum(case when p.status = 'failed' then 1 else 0 end) as failed_payments_last_90d
    from "saas_analytics"."main_staging"."stg_payments" p
    join "saas_analytics"."main_staging"."stg_subscriptions" s
        on p.subscription_id = s.subscription_id
    cross join as_of a
    where p.payment_date > a.as_of_date - interval 90 day
      and p.payment_date <= a.as_of_date
    group by 1
),

scored as (
    select
        c.customer_id,
        a.as_of_date,
        coalesce(u.events_last_30d, 0) as events_last_30d,
        coalesce(u.usage_quantity_last_30d, 0) as usage_quantity_last_30d,
        coalesce(t.tickets_created_last_90d, 0) as tickets_created_last_90d,
        coalesce(t.open_tickets, 0) as open_tickets,
        coalesce(p.payment_events_last_90d, 0) as payment_events_last_90d,
        coalesce(p.failed_payments_last_90d, 0) as failed_payments_last_90d,
        case
            when coalesce(p.payment_events_last_90d, 0) = 0 then 0
            else coalesce(p.failed_payments_last_90d, 0)::double / p.payment_events_last_90d
        end as payment_failure_rate_last_90d
    from customers c
    cross join as_of a
    left join usage_last_30d u
        on c.customer_id = u.customer_id
    left join tickets_last_90d t
        on c.customer_id = t.customer_id
    left join payment_failures_last_90d p
        on c.customer_id = p.customer_id
),

final as (
    select
        customer_id,
        as_of_date,
        events_last_30d,
        usage_quantity_last_30d,
        tickets_created_last_90d,
        open_tickets,
        payment_events_last_90d,
        failed_payments_last_90d,
        payment_failure_rate_last_90d,
        least(
            100,
            greatest(
                0,
                70
                + least(30, events_last_30d)::integer
                - least(40, open_tickets * 10)::integer
                - least(40, (payment_failure_rate_last_90d * 100)::integer)
            )
        ) as health_score
    from scored
)

select *
from final