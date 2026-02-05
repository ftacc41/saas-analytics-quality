view: cohort_retention {
  sql_table_name: cohort_retention ;;
  
  dimension: cohort_segment_period_id {
    type: string
    sql: ${TABLE}.cohort_segment_period_id ;;
    description: "Unique identifier for cohort-segment-period combination"
  }
  
  dimension: cohort_month {
    type: date
    sql: ${TABLE}.cohort_month ;;
    description: "Cohort month (signup month)"
    timeframes: [raw, date, week, month, quarter, year]
  }
  
  dimension: customer_segment {
    type: string
    sql: ${TABLE}.customer_segment ;;
    description: "Customer segment (smb, mid-market, enterprise)"
  }
  
  dimension: months_since_signup {
    type: number
    sql: ${TABLE}.months_since_signup ;;
    description: "Months since cohort signup"
    value_format_name: "#,##0"
  }
  
  dimension: active_month {
    type: date
    sql: ${TABLE}.active_month ;;
    description: "Month when retention is measured"
    timeframes: [raw, date, week, month, quarter, year]
  }
  
  measure: cohort_customers {
    type: sum
    sql: ${TABLE}.cohort_customers ;;
    description: "Number of customers in cohort"
    value_format_name: "#,##0"
  }
  
  measure: active_customers {
    type: sum
    sql: ${TABLE}.active_customers ;;
    description: "Number of active customers in period"
    value_format_name: "#,##0"
  }
  
  measure: retention_rate {
    type: average
    sql: ${TABLE}.retention_rate ;;
    description: "Retention rate (0-1)"
    value_format_name: "#0.00%"
  }
}
