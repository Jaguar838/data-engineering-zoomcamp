{{ config(materialized='table') }}

WITH trip_duration_calc AS (
    SELECT
    year,
    month,
    PUlocationID,
    pickup_zone,
    DOlocationID,
    dropoff_zone,
    TIMESTAMP_DIFF(dropOff_datetime, pickup_datetime, SECOND) AS trip_duration
FROM {{ ref('dim_fhv_trips') }}
)
SELECT 
    year,
    month,
    pickup_zone,
    dropoff_zone,
    PERCENTILE_CONT(trip_duration,0.90) OVER (PARTITION BY year, month, PULocationID, DOlocationID) AS p90
FROM trip_duration_calc