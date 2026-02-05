connection: "saas_analytics"

include: "/views/**/*.view.lkml"

explore: fct_monthly_recurring_revenue {
  label: "Monthly Recurring Revenue"
  description: "MRR by customer and month (1.1, 1.2, 1.8)"
}

explore: dim_customers {
  label: "Customers"
  description: "Customer dimension (1.3, 1.4)"
}

explore: churn_analysis {
  label: "Churn Analysis"
  description: "Churn metrics by segment and month (1.5, 1.6, 3.1-3.4)"
}

explore: mrr_analysis {
  label: "MRR Analysis"
  description: "MRR movement breakdown (1.7, 1.9, 2.1, 2.3-2.5)"
}

explore: cohort_retention {
  label: "Cohort Retention"
  description: "Cohort retention metrics (4.1-4.4)"
}

explore: unit_economics {
  label: "Unit Economics"
  description: "LTV, CAC, ARPU, payback (5.1-5.5)"
}

explore: fct_subscriptions {
  label: "Subscriptions"
  description: "Subscriptions with plan details (1.10, 2.2)"
  join: dim_plans {
    type: left_outer
    relationship: many_to_one
    sql_on: ${fct_subscriptions.plan_id} = ${dim_plans.plan_id} ;;
  }
}
