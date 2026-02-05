view: unit_economics {
  sql_table_name: unit_economics ;;
  
  dimension: segment_as_of_id {
    type: string
    sql: ${TABLE}.segment_as_of_id ;;
    description: "Unique identifier for segment-as-of-month combination"
  }
  
  dimension: as_of_month {
    type: date
    sql: ${TABLE}.as_of_month ;;
    description: "As-of month for the metrics"
    timeframes: [raw, date, week, month, quarter, year]
  }
  
  dimension: customer_segment {
    type: string
    sql: ${TABLE}.customer_segment ;;
    description: "Customer segment (smb, mid-market, enterprise)"
  }
  
  dimension: payback_months {
    type: number
    sql: ${TABLE}.payback_months ;;
    description: "Payback period in months"
    value_format_name: "#,##0.00"
  }
  
  dimension: payback_months_bucket {
    type: number
    sql: FLOOR(${TABLE}.payback_months / 3) * 3 ;;
    value_format_name: "#,##0"
    description: "Payback months in buckets of 3 (0-2, 3-5, 6-8, ...)"
  }
  
  measure: arpu {
    type: average
    sql: ${TABLE}.arpu ;;
    description: "Average revenue per user"
    value_format_name: "$#,##0.00"
  }
  
  measure: avg_monthly_customer_churn_rate {
    type: average
    sql: ${TABLE}.avg_monthly_customer_churn_rate ;;
    description: "Average monthly customer churn rate"
    value_format_name: "#0.00%"
  }
  
  measure: expected_lifetime_months {
    type: average
    sql: ${TABLE}.expected_lifetime_months ;;
    description: "Expected lifetime in months"
    value_format_name: "#,##0.00"
  }
  
  measure: lifetime_value {
    type: average
    sql: ${TABLE}.lifetime_value ;;
    description: "Customer lifetime value"
    value_format_name: "$#,##0.00"
  }
  
  measure: assumed_cac {
    type: average
    sql: ${TABLE}.assumed_cac ;;
    description: "Assumed customer acquisition cost"
    value_format_name: "$#,##0.00"
  }
  
  measure: ltv_to_cac_ratio {
    type: average
    sql: ${TABLE}.ltv_to_cac_ratio ;;
    description: "LTV to CAC ratio"
    value_format_name: "#,##0.00"
  }
  
  measure: payback_months_avg {
    type: average
    sql: ${TABLE}.payback_months ;;
    description: "Average payback period in months"
    value_format_name: "#,##0.00"
  }
}
