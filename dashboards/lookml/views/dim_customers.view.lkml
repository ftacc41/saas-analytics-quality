view: dim_customers {
  sql_table_name: dim_customers ;;
  
  dimension: customer_id {
    type: number
    sql: ${TABLE}.customer_id ;;
    description: "Customer identifier"
    value_format_name: "#,##0"
  }
  
  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    description: "Customer email"
  }
  
  dimension: company_name {
    type: string
    sql: ${TABLE}.company_name ;;
    description: "Company name"
  }
  
  dimension: industry {
    type: string
    sql: ${TABLE}.industry ;;
    description: "Industry"
  }
  
  dimension: company_size {
    type: string
    sql: ${TABLE}.company_size ;;
    description: "Company size"
  }
  
  dimension: customer_segment {
    type: string
    sql: ${TABLE}.customer_segment ;;
    description: "Customer segment (smb, mid-market, enterprise)"
  }
  
  dimension: country {
    type: string
    sql: ${TABLE}.country ;;
    description: "Country"
  }
  
  dimension: signup_date {
    type: date
    sql: ${TABLE}.signup_date ;;
    description: "Customer signup date"
    timeframes: [raw, date, week, month, quarter, year]
  }
  
  dimension: churn_date {
    type: date
    sql: ${TABLE}.churn_date ;;
    description: "Customer churn date"
    timeframes: [raw, date, week, month, quarter, year]
  }
  
  dimension: account_status {
    type: string
    sql: ${TABLE}.account_status ;;
    description: "Account status"
  }
  
  dimension: is_active {
    type: yesno
    sql: ${TABLE}.is_active ;;
    description: "Whether the account is active"
  }
  
  measure: customer_count {
    type: count_distinct
    sql: ${customer_id} ;;
    description: "Count of distinct customers"
    value_format_name: "#,##0"
  }
}
