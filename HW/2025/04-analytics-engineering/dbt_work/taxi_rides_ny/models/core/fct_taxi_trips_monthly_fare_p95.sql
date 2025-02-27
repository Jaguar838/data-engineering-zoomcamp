{{ config(materialized='table') }}

WITH out_invalid AS (
    SELECT * 
    FROM {{ ref('fact_trips') }}
    WHERE fare_amount > 0
        AND trip_distance > 0
        AND payment_type_description IN ('Cash', 'Credit Card') 
),
percentile_calc AS (
    SELECT
        service_type,
        year,
        month,
        fare_amount,
        PERCENTILE_CONT(fare_amount,0.97) OVER (PARTITION BY service_type, year, month) AS p97,
        PERCENTILE_CONT(fare_amount, 0.95) OVER (PARTITION BY service_type, year, month) AS p95,
        PERCENTILE_CONT(fare_amount, 0.90) OVER (PARTITION BY service_type, year, month) AS p90
    FROM out_invalid
)
SELECT *
FROM percentile_calc