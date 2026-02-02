view: churn_analysis {
  sql_table_name: churn_analysis ;;
  
  dimension: segment_month_id {
    type: string
    sql: ${TABLE}.segment_month_id ;;
    description: "Unique identifier for segment-month combination"
  }
  
  dimension: date_month {
    type: date
    sql: ${TABLE}.date_month ;;
    description: "Month for the churn metrics"
    timeframes: [raw, date, week, month, quarter, year]
  }
  
  dimension: customer_segment {
    type: string
    sql: ${TABLE}.customer_segment ;;
    description: "Customer segment (smb, mid-market, enterprise)"
  }
  
  measure: starting_customers {
    type: sum
    sql: ${TABLE}.starting_customers ;;
    description: "Number of customers at start of month"
    value_format_name: "#,##0"
  }
  
  measure: churned_customers {
    type: sum
    sql: ${TABLE}.churned_customers ;;
    description: "Number of customers who churned in the month"
    value_format_name: "#,##0"
  }
  
  measure: customer_churn_rate {
    type: average
    sql: ${TABLE}.customer_churn_rate ;;
    description: "Customer churn rate (0-1)"
    value_format_name: "#0.00%"
  }
  
  measure: starting_mrr {
    type: sum
    sql: ${TABLE}.starting_mrr ;;
    description: "MRR at start of month"
    value_format_name: "$#,##0.00"
  }
  
  measure: churned_mrr {
    type: sum
    sql: ${TABLE}.churned_mrr ;;
    description: "MRR lost from churned customers"
    value_format_name: "$#,##0.00"
  }
  
  measure: revenue_churn_rate {
    type: average
    sql: ${TABLE}.revenue_churn_rate ;;
    description: "Revenue churn rate (0-1)"
    value_format_name: "#0.00%"
  }
}
