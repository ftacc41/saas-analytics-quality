view: fct_monthly_recurring_revenue {
  sql_table_name: fct_monthly_recurring_revenue ;;
  
  dimension: customer_month_id {
    type: string
    sql: ${TABLE}.customer_month_id ;;
    description: "Unique identifier for customer-month combination"
  }
  
  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
    description: "Customer identifier"
    value_format_name: "#,##0"
  }
  
  dimension: date_month {
    type: date
    sql: ${TABLE}.date_month ;;
    description: "Month for the MRR"
    timeframes: [raw, date, week, month, quarter, year]
  }
  
  dimension: subscription_count {
    type: number
    sql: ${TABLE}.subscription_count ;;
    description: "Number of subscriptions"
    value_format_name: "#,##0"
  }
  
  measure: mrr_amount {
    type: sum
    sql: ${TABLE}.mrr_amount ;;
    description: "Monthly recurring revenue amount"
    value_format_name: "$#,##0.00"
  }
}
