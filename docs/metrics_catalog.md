# SaaS Metrics Catalog

This document defines the key business metrics used in this analytics platform. All metrics are implemented in the dbt marts layer and power the Looker Studio dashboards.

---

## Revenue Metrics

### Monthly Recurring Revenue (MRR)

| Attribute | Value |
|-----------|-------|
| **Definition** | Sum of all active subscription revenue normalized to a monthly basis |
| **Formula** | `SUM(mrr_amount)` where subscription is active |
| **Unit** | USD |
| **Granularity** | Customer, Month |
| **Source Model** | `fct_monthly_recurring_revenue` |

**Business Context:** MRR is the foundation of SaaS financial health. Annual subscriptions are divided by 12 to normalize to monthly.

---

### Annual Recurring Revenue (ARR)

| Attribute | Value |
|-----------|-------|
| **Definition** | MRR multiplied by 12 |
| **Formula** | `MRR * 12` |
| **Unit** | USD |
| **Source Model** | Calculated from `fct_monthly_recurring_revenue` |

---

### New MRR

| Attribute | Value |
|-----------|-------|
| **Definition** | MRR from customers who had $0 MRR in the prior month and >$0 in the current month |
| **Formula** | `SUM(mrr_amount)` where `prior_month_mrr = 0 AND current_mrr > 0` |
| **Unit** | USD |
| **Source Model** | `mrr_analysis` |

---

### Expansion MRR

| Attribute | Value |
|-----------|-------|
| **Definition** | Increase in MRR from existing customers (upgrades, add-ons) |
| **Formula** | `SUM(current_mrr - prior_mrr)` where `current_mrr > prior_mrr AND prior_mrr > 0` |
| **Unit** | USD |
| **Source Model** | `mrr_analysis` |

---

### Contraction MRR

| Attribute | Value |
|-----------|-------|
| **Definition** | Decrease in MRR from existing customers (downgrades) |
| **Formula** | `SUM(prior_mrr - current_mrr)` where `current_mrr < prior_mrr AND current_mrr > 0` |
| **Unit** | USD |
| **Source Model** | `mrr_analysis` |

---

### Churned MRR

| Attribute | Value |
|-----------|-------|
| **Definition** | MRR lost from customers who cancelled (MRR went to $0) |
| **Formula** | `SUM(prior_mrr)` where `prior_mrr > 0 AND current_mrr = 0` |
| **Unit** | USD |
| **Source Model** | `mrr_analysis` |

---

### Net New MRR

| Attribute | Value |
|-----------|-------|
| **Definition** | Net change in MRR after all movements |
| **Formula** | `New MRR + Expansion MRR - Contraction MRR - Churned MRR` |
| **Unit** | USD |
| **Source Model** | `mrr_analysis` |

---

## Customer Metrics

### Customer Churn Rate

| Attribute | Value |
|-----------|-------|
| **Definition** | Percentage of customers lost in a period |
| **Formula** | `Churned Customers / Starting Customers` |
| **Unit** | Percentage (0-1) |
| **Granularity** | Month, Segment |
| **Source Model** | `churn_analysis` |

**Interpretation:**
- < 2% monthly: Excellent
- 2-5% monthly: Acceptable
- > 5% monthly: Concerning

---

### Revenue Churn Rate

| Attribute | Value |
|-----------|-------|
| **Definition** | Percentage of MRR lost in a period |
| **Formula** | `Churned MRR / Starting MRR` |
| **Unit** | Percentage (0-1) |
| **Granularity** | Month, Segment |
| **Source Model** | `churn_analysis` |

**Note:** Revenue churn often differs from customer churn because higher-value customers may churn at different rates.

---

### Average Revenue Per User (ARPU)

| Attribute | Value |
|-----------|-------|
| **Definition** | Average MRR per active customer |
| **Formula** | `Total MRR / Active Customers` |
| **Unit** | USD |
| **Granularity** | Month, Segment |
| **Source Model** | `customer_lifetime_value` |

---

## Growth Metrics

### Quick Ratio

| Attribute | Value |
|-----------|-------|
| **Definition** | Ratio of growth activities to contraction activities |
| **Formula** | `(New MRR + Expansion MRR) / (Contraction MRR + Churned MRR)` |
| **Unit** | Ratio |
| **Source Model** | `mrr_analysis` |

**Interpretation:**
- > 4: Excellent growth efficiency
- 2-4: Healthy
- 1-2: Struggling
- < 1: Shrinking

---

### Net Revenue Retention (NRR)

| Attribute | Value |
|-----------|-------|
| **Definition** | Revenue retained from existing customers including expansion |
| **Formula** | `(Starting MRR + Expansion - Contraction - Churn) / Starting MRR` |
| **Unit** | Percentage |
| **Granularity** | Month, Segment |
| **Source Model** | `net_revenue_retention` |

**Interpretation:**
- > 120%: World-class (expansion exceeds churn significantly)
- 100-120%: Healthy
- < 100%: Revenue is shrinking from existing customers

---

### Gross Revenue Retention (GRR)

| Attribute | Value |
|-----------|-------|
| **Definition** | Revenue retained from existing customers excluding expansion |
| **Formula** | `(Starting MRR - Contraction - Churn) / Starting MRR` |
| **Unit** | Percentage |
| **Granularity** | Month, Segment |
| **Source Model** | `net_revenue_retention` |

**Note:** GRR is always ≤ 100% and represents the "floor" of retention.

---

## Lifetime Value Metrics

### Customer Lifetime Value (LTV)

| Attribute | Value |
|-----------|-------|
| **Definition** | Estimated total revenue from a customer over their lifetime |
| **Formula** | `ARPU / Monthly Churn Rate` or `ARPU * Expected Lifetime Months` |
| **Unit** | USD |
| **Granularity** | Segment |
| **Source Model** | `customer_lifetime_value` |

**Assumptions:**
- Uses average monthly churn rate from recent months
- Expected lifetime capped at 120 months for sanity

---

### Expected Lifetime Months

| Attribute | Value |
|-----------|-------|
| **Definition** | Average expected customer lifespan |
| **Formula** | `1 / Monthly Churn Rate` |
| **Unit** | Months |
| **Source Model** | `customer_lifetime_value` |

---

### LTV/CAC Ratio

| Attribute | Value |
|-----------|-------|
| **Definition** | Lifetime value relative to customer acquisition cost |
| **Formula** | `LTV / CAC` |
| **Unit** | Ratio |
| **Source Model** | `unit_economics` |

**Note:** CAC is assumed/configurable in this project since we don't have marketing spend data.

**Interpretation:**
- > 3: Healthy (standard benchmark)
- 1-3: May need improvement
- < 1: Losing money on customer acquisition

---

### Payback Period

| Attribute | Value |
|-----------|-------|
| **Definition** | Months to recover customer acquisition cost |
| **Formula** | `CAC / ARPU` |
| **Unit** | Months |
| **Source Model** | `unit_economics` |

**Interpretation:**
- < 12 months: Excellent
- 12-18 months: Acceptable
- > 18 months: Capital intensive

---

## Cohort Metrics

### Cohort Retention Rate

| Attribute | Value |
|-----------|-------|
| **Definition** | Percentage of customers from a signup cohort still active after N months |
| **Formula** | `Active Customers at Month N / Original Cohort Size` |
| **Unit** | Percentage (0-1) |
| **Granularity** | Cohort Month, Segment, Months Since Signup |
| **Source Model** | `cohort_retention` |

---

## Segmentation

All metrics are available segmented by:

| Segment | Values |
|---------|--------|
| **Customer Segment** | `smb`, `mid-market`, `enterprise` |
| **Plan Tier** | `starter`, `professional`, `enterprise` |
| **Cohort Month** | Signup month (YYYY-MM) |

---

## Data Freshness

| Model | Update Frequency | Freshness SLA |
|-------|------------------|---------------|
| `fct_monthly_recurring_revenue` | Daily | 24 hours |
| `mrr_analysis` | Daily | 24 hours |
| `churn_analysis` | Daily | 24 hours |
| `cohort_retention` | Daily | 24 hours |
| `customer_lifetime_value` | Daily | 24 hours |
| `unit_economics` | Daily | 24 hours |
