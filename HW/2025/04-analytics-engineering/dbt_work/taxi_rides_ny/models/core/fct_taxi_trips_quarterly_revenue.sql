{{ config(materialized='table') }}

WITH quarterly_revenue AS (
SELECT 
service_type,
year_quarter,
year,
quarter,
SUM (total_amount) AS revenue_per_quater
FROM {{ ref('fact_trips') }}
WHERE year IN (2019, 2020)
GROUP BY service_type, year, quarter, year_quarter
),
quarterly_growth AS (
  SELECT
  service_type,
  year_quarter,
  year,
  quarter,
  revenue_per_quater,
  LAG(revenue_per_quater) OVER (PARTITION BY service_type, quarter ORDER BY year) AS prev_year_revenue,
  SAFE_DIVIDE (
    revenue_per_quater - LAG(revenue_per_quater) OVER (PARTITION BY service_type, quarter ORDER BY year), LAG(revenue_per_quater) OVER (PARTITION BY service_type, quarter ORDER BY year)
  ) * 100 AS yoy_growth
  FROM quarterly_revenue
)
SELECT
service_type,
year_quarter,
year,
quarter,
revenue_per_quater,
prev_year_revenue,
yoy_growth
FROM quarterly_growth
ORDER BY service_type, quarter