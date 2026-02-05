view: fct_subscriptions {
  sql_table_name: fct_subscriptions ;;
  
  dimension: subscription_id {
    type: number
    sql: ${TABLE}.subscription_id ;;
    description: "Subscription identifier"
    value_format_name: "#,##0"
  }
  
  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
    description: "Customer identifier"
    value_format_name: "#,##0"
  }
  
  dimension: plan_id {
    type: number
    sql: ${TABLE}.plan_id ;;
    description: "Plan identifier"
    value_format_name: "#,##0"
  }
  
  dimension: start_date {
    type: date
    sql: ${TABLE}.start_date ;;
    description: "Subscription start date"
    timeframes: [raw, date, week, month, quarter, year]
  }
  
  dimension: end_date {
    type: date
    sql: ${TABLE}.end_date ;;
    description: "Subscription end date"
    timeframes: [raw, date, week, month, quarter, year]
  }
  
  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    description: "Subscription status"
  }
  
  dimension: billing_cycle {
    type: string
    sql: ${TABLE}.billing_cycle ;;
    description: "Billing cycle"
  }
  
  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
    description: "Subscription amount"
    value_format_name: "$#,##0.00"
  }
  
  dimension: is_currently_active {
    type: yesno
    sql: ${TABLE}.is_currently_active ;;
    description: "Whether the subscription is currently active"
  }
  
  measure: mrr_amount {
    type: sum
    sql: ${TABLE}.mrr_amount ;;
    description: "Monthly recurring revenue amount"
    value_format_name: "$#,##0.00"
  }
}
