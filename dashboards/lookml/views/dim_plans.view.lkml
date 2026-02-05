view: dim_plans {
  sql_table_name: dim_plans ;;
  
  dimension: plan_id {
    type: number
    sql: ${TABLE}.plan_id ;;
    description: "Plan identifier"
    value_format_name: "#,##0"
  }
  
  dimension: plan_name {
    type: string
    sql: ${TABLE}.plan_name ;;
    description: "Plan name"
  }
  
  dimension: plan_tier {
    type: string
    sql: ${TABLE}.plan_tier ;;
    description: "Plan tier"
  }
  
  dimension: base_price_monthly {
    type: number
    sql: ${TABLE}.base_price_monthly ;;
    description: "Base price (monthly)"
    value_format_name: "$#,##0.00"
  }
  
  dimension: base_price_annual {
    type: number
    sql: ${TABLE}.base_price_annual ;;
    description: "Base price (annual)"
    value_format_name: "$#,##0.00"
  }
  
  dimension: max_users {
    type: number
    sql: ${TABLE}.max_users ;;
    description: "Maximum users"
    value_format_name: "#,##0"
  }
  
  dimension: features {
    type: string
    sql: ${TABLE}.features ;;
    description: "Plan features"
  }
  
  dimension: created_date {
    type: date
    sql: ${TABLE}.created_date ;;
    description: "Plan created date"
    timeframes: [raw, date, week, month, quarter, year]
  }
}
