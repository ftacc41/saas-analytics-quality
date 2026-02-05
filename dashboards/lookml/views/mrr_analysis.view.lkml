view: mrr_analysis {
  sql_table_name: mrr_analysis ;;
  
  dimension: segment_month_id {
    type: string
    sql: ${TABLE}.segment_month_id ;;
    description: "Unique identifier for segment-month combination"
  }
  
  dimension: date_month {
    type: date
    sql: ${TABLE}.date_month ;;
    description: "Month for the MRR metrics"
    timeframes: [raw, date, week, month, quarter, year]
  }
  
  dimension: customer_segment {
    type: string
    sql: ${TABLE}.customer_segment ;;
    description: "Customer segment (smb, mid-market, enterprise)"
  }
  
  measure: total_mrr {
    type: sum
    sql: ${TABLE}.total_mrr ;;
    description: "Total MRR for the month"
    value_format_name: "$#,##0.00"
  }
  
  measure: new_mrr {
    type: sum
    sql: ${TABLE}.new_mrr ;;
    description: "MRR from new customers"
    value_format_name: "$#,##0.00"
  }
  
  measure: expansion_mrr {
    type: sum
    sql: ${TABLE}.expansion_mrr ;;
    description: "MRR from expansion"
    value_format_name: "$#,##0.00"
  }
  
  measure: contraction_mrr {
    type: sum
    sql: ${TABLE}.contraction_mrr ;;
    description: "MRR lost from contraction"
    value_format_name: "$#,##0.00"
  }
  
  measure: churned_mrr {
    type: sum
    sql: ${TABLE}.churned_mrr ;;
    description: "MRR lost from churned customers"
    value_format_name: "$#,##0.00"
  }
  
  measure: net_new_mrr {
    type: sum
    sql: ${TABLE}.net_new_mrr ;;
    description: "Net new MRR (new + expansion - contraction - churn)"
    value_format_name: "$#,##0.00"
  }
  
  measure: quick_ratio {
    type: number
    sql: (${new_mrr} + ${expansion_mrr}) / NULLIF(${contraction_mrr} + ${churned_mrr}, 0) ;;
    value_format_name: "#,##0.00"
    description: "Quick Ratio = (New MRR + Expansion MRR) / (Contraction MRR + Churned MRR)"
  }
}
