# Dashboard Building Guide

This guide lists each visualization with **which Explores to use** (and which to join), and exactly what to place in **Dimensions**, **Measures**, **Filters**, and **Visualization Types** in Looker.

---

## Dashboard 1: Executive Summary

### 1.1 Current MRR (KPI)

| | |
|---|---|
| **Explore** | `fct_monthly_recurring_revenue` |
| **Join** | None |
| **Dimension** | — |
| **Measure** | `mrr_amount` (sum) |
| **Filters** | `date_month` = MAX(`date_month`) |
| **Viz Type** | **Single Value** or **Number** |

---

### 1.2 MoM MRR Growth % (KPI)

| | |
|---|---|
| **Explore** | `fct_monthly_recurring_revenue` |
| **Join** | None |
| **Dimension** | — |
| **Measure** | Create calculated measure: `(mrr_amount_current_month - mrr_amount_previous_month) / mrr_amount_previous_month` |
| **Filters** | Use table calculations or time-based filters to compare current vs previous month |
| **Viz Type** | **Single Value** or **Number** (formatted as %) |

---

### 1.3 Total Customers (KPI)

| | |
|---|---|
| **Explore** | `dim_customers` |
| **Join** | None |
| **Dimension** | — |
| **Measure** | `customer_id` (count distinct) |
| **Filters** | — |
| **Viz Type** | **Single Value** or **Number** |

---

### 1.4 New Customers This Month (KPI)

| | |
|---|---|
| **Explore** | `dim_customers` |
| **Join** | None |
| **Dimension** | — |
| **Measure** | `customer_id` (count distinct) |
| **Filters** | `signup_date` in current month (use relative date filter) |
| **Viz Type** | **Single Value** or **Number** |

---

### 1.5 Customer Churn Rate (KPI)

| | |
|---|---|
| **Explore** | `churn_analysis` |
| **Join** | None |
| **Dimension** | — |
| **Measure** | `customer_churn_rate` (average, formatted as %) |
| **Filters** | `date_month` = MAX(`date_month`) |
| **Viz Type** | **Single Value** or **Number** |

---

### 1.6 Revenue Churn Rate (KPI)

| | |
|---|---|
| **Explore** | `churn_analysis` |
| **Join** | None |
| **Dimension** | — |
| **Measure** | `revenue_churn_rate` (average, formatted as %) |
| **Filters** | `date_month` = MAX(`date_month`) |
| **Viz Type** | **Single Value** or **Number** |

---

### 1.7 Quick Ratio (KPI)

| | |
|---|---|
| **Explore** | `mrr_analysis` |
| **Join** | None |
| **Dimension** | — |
| **Measure** | Create calculated measure: `(new_mrr + expansion_mrr) / (contraction_mrr + churned_mrr)` |
| **Filters** | `date_month` = MAX(`date_month`) |
| **Viz Type** | **Single Value** or **Number** |

---

### 1.8 MRR Trend (Line Chart)

| | |
|---|---|
| **Explore** | `fct_monthly_recurring_revenue` |
| **Join** | None |
| **Dimension** | `date_month` (formatted as Month) |
| **Measure** | `mrr_amount` (sum) |
| **Filters** | `date_month`: last 12 months |
| **Viz Type** | **Line Chart** |

---

### 1.9 MRR Waterfall

| | |
|---|---|
| **Explore** | `mrr_analysis` |
| **Join** | None |
| **Dimension** | Create dimension for Stage: Starting MRR, New, Expansion, Contraction, Churned, Ending MRR |
| **Measure** | Create calculated measures for each stage delta (use table calculations for running total) |
| **Filters** | `date_month` = MAX(`date_month`) |
| **Viz Type** | **Bar Chart** (waterfall style); **Color** by positive vs negative (green / red) |

---

### 1.10 Top 5 Plans by Revenue

| | |
|---|---|
| **Explore** | `fct_subscriptions` (joined with `dim_plans` on `plan_id`) |
| **Join** | `fct_subscriptions` ↔ `dim_plans` on `plan_id` |
| **Dimension** | `plan_name` or `plan_tier` |
| **Measure** | `mrr_amount` (sum) |
| **Filters** | `status` = `'active'`; Limit to Top 5 by `mrr_amount` |
| **Viz Type** | **Bar Chart** (horizontal); optionally **Color** by `plan_tier` |

---

## Dashboard 2: MRR Deep Dive

### 2.1 MRR by Customer Segment over Time (Stacked Area)

| | |
|---|---|
| **Explore** | `mrr_analysis` |
| **Join** | None |
| **Dimension** | `date_month` |
| **Measure** | `total_mrr` (sum) |
| **Pivot** | `customer_segment` |
| **Filters** | Optional: last 12–24 months |
| **Viz Type** | **Area Chart** (stacked); **Color** by `customer_segment` |

---

### 2.2 Current MRR by Plan Tier (Stacked Bar)

| | |
|---|---|
| **Explore** | `fct_subscriptions` (joined with `dim_plans` on `plan_id`) |
| **Join** | `fct_subscriptions` ↔ `dim_plans` on `plan_id` |
| **Dimension** | `plan_tier` |
| **Measure** | `mrr_amount` (sum) |
| **Filters** | `status` = `'active'` |
| **Viz Type** | **Bar Chart** (stacked); **Color** by `plan_tier` |

---

### 2.3 MRR Movement Breakdown (Grouped Bar)

| | |
|---|---|
| **Explore** | `mrr_analysis` |
| **Join** | None |
| **Dimension** | `date_month` |
| **Measures** | `new_mrr` (sum), `expansion_mrr` (sum), `contraction_mrr` (sum), `churned_mrr` (sum) |
| **Pivot** | Use multiple measures or create a dimension for MRR movement type |
| **Filters** | `date_month`: last 12 months |
| **Viz Type** | **Bar Chart** (grouped); **Color** by MRR movement type |

---

### 2.4 New vs Expansion MRR (Dual-Axis Line)

| | |
|---|---|
| **Explore** | `mrr_analysis` |
| **Join** | None |
| **Dimension** | `date_month` |
| **Measures** | `new_mrr` (sum), `expansion_mrr` (sum) |
| **Filters** | Optional: last 12 months |
| **Viz Type** | **Line Chart** (dual-axis or multiple series); **Color** by series (New vs Expansion) |

---

### 2.5 MRR by Customer Segment — Latest Month (Bar)

| | |
|---|---|
| **Explore** | `mrr_analysis` |
| **Join** | None |
| **Dimension** | `customer_segment` |
| **Measure** | `total_mrr` (sum) |
| **Filters** | `date_month` = MAX(`date_month`) |
| **Viz Type** | **Bar Chart** |

---

## Dashboard 3: Churn Analysis

### 3.1 Churn Rate Trend (Dual-Axis Line)

| | |
|---|---|
| **Explore** | `churn_analysis` |
| **Join** | None |
| **Dimension** | `date_month` |
| **Measures** | `customer_churn_rate` (average), `revenue_churn_rate` (average) |
| **Filters** | `date_month`: last 12 months |
| **Viz Type** | **Line Chart** (dual-axis or multiple series); **Color** by series |

---

### 3.2 Churn by Customer Segment (Bar)

| | |
|---|---|
| **Explore** | `churn_analysis` |
| **Join** | None |
| **Dimension** | `customer_segment` |
| **Measure** | `customer_churn_rate` (average) |
| **Filters** | `date_month` = MAX(`date_month`) |
| **Viz Type** | **Bar Chart** |

---

### 3.3 Churned Customers Count (Column)

| | |
|---|---|
| **Explore** | `churn_analysis` |
| **Join** | None |
| **Dimension** | `date_month` |
| **Measure** | `churned_customers` (sum) |
| **Filters** | Optional: last 12 months |
| **Viz Type** | **Bar Chart** (vertical) |

---

### 3.4 Churned MRR Amount (Column)

| | |
|---|---|
| **Explore** | `churn_analysis` |
| **Join** | None |
| **Dimension** | `date_month` |
| **Measure** | `churned_mrr` (sum) |
| **Filters** | Optional: last 12 months |
| **Viz Type** | **Bar Chart** (vertical) |

---

## Dashboard 4: Cohort Retention

### 4.1 Cohort Retention Heatmap

| | |
|---|---|
| **Explore** | `cohort_retention` |
| **Join** | None |
| **Dimension** | `cohort_month`, `months_since_signup` |
| **Measure** | `retention_rate` (average) |
| **Filters** | Optional: filter `customer_segment` or `cohort_month` |
| **Viz Type** | **Heatmap** or **Table**; **Color** by `retention_rate` |

---

### 4.2 Retention Curves by Cohort (Line)

| | |
|---|---|
| **Explore** | `cohort_retention` |
| **Join** | None |
| **Dimension** | `months_since_signup` |
| **Measure** | `retention_rate` (average) |
| **Pivot** | `cohort_month` |
| **Filters** | Optional: filter cohorts |
| **Viz Type** | **Line Chart**; **Color** by `cohort_month` |

---

### 4.3 Best / Worst Performing Cohorts (Bar)

| | |
|---|---|
| **Explore** | `cohort_retention` |
| **Join** | None |
| **Dimension** | `cohort_month` |
| **Measure** | `retention_rate` (average) |
| **Filters** | `months_since_signup` = 12 (or chosen period) |
| **Viz Type** | **Bar Chart**; sort by `retention_rate` descending |

---

### 4.4 Retention by Customer Segment (Line)

| | |
|---|---|
| **Explore** | `cohort_retention` |
| **Join** | None |
| **Dimension** | `months_since_signup` |
| **Measure** | `retention_rate` (average) |
| **Pivot** | `customer_segment` |
| **Filters** | Optional |
| **Viz Type** | **Line Chart**; **Color** by `customer_segment` |

---

## Dashboard 5: Unit Economics

### 5.1 LTV by Customer Segment (Bar)

| | |
|---|---|
| **Explore** | `unit_economics` |
| **Join** | None |
| **Dimension** | `customer_segment` |
| **Measure** | `lifetime_value` (average) |
| **Filters** | `as_of_month` = MAX(`as_of_month`) |
| **Viz Type** | **Bar Chart** |

---

### 5.2 LTV Trends over Time (Line)

| | |
|---|---|
| **Explore** | `unit_economics` |
| **Join** | None |
| **Dimension** | `as_of_month` |
| **Measure** | `lifetime_value` (average) |
| **Pivot** | `customer_segment` |
| **Filters** | — |
| **Viz Type** | **Line Chart**; **Color** by `customer_segment` |

---

### 5.3 LTV/CAC Ratio (Bar + Reference Line)

| | |
|---|---|
| **Explore** | `unit_economics` |
| **Join** | None |
| **Dimension** | `customer_segment` |
| **Measure** | `ltv_to_cac_ratio` (average) |
| **Filters** | `as_of_month` = MAX(`as_of_month`) |
| **Viz Type** | **Bar Chart**; add **Reference Line** (constant 3.0) |

---

### 5.4 Payback Period Distribution (Histogram)

| | |
|---|---|
| **Explore** | `unit_economics` |
| **Join** | None |
| **Dimension** | `payback_months` (create bins with size 1 or 3) |
| **Measure** | Count of records (or `segment_as_of_id` count) |
| **Filters** | `as_of_month` = MAX(`as_of_month`) |
| **Viz Type** | **Bar Chart** (histogram); optionally **Color** by `customer_segment` |

---

### 5.5 ARPU by Segment (Bar)

| | |
|---|---|
| **Explore** | `unit_economics` |
| **Join** | None |
| **Dimension** | `customer_segment` |
| **Measure** | `arpu` (average) |
| **Filters** | `as_of_month` = MAX(`as_of_month`) |
| **Viz Type** | **Bar Chart** |

---

## Which Explores to Use (Summary)

| Visualization | Explore | Join |
|---------------|---------|------|
| 1.1–1.2, 1.8 | `fct_monthly_recurring_revenue` | None |
| 1.3–1.4 | `dim_customers` | None |
| 1.5–1.6 | `churn_analysis` | None |
| 1.7, 1.9 | `mrr_analysis` | None |
| 1.10 | `fct_subscriptions` (with `dim_plans`) | On `plan_id` |
| 2.1, 2.3–2.5 | `mrr_analysis` | None |
| 2.2 | `fct_subscriptions` (with `dim_plans`) | On `plan_id` |
| 3.1–3.4 | `churn_analysis` | None |
| 4.1–4.4 | `cohort_retention` | None |
| 5.1–5.5 | `unit_economics` | None |

---

## Next Steps

1. Set up Looker connection to DuckDB (see SETUP_GUIDE.md).
2. Create LookML models and explores for each table.
3. Build the Executive Summary dashboard first, then add other dashboards.
4. Create one Look per visualization using the Dimensions / Measures / Filters / Viz Types above.
5. Test with real data and take screenshots for your portfolio.
