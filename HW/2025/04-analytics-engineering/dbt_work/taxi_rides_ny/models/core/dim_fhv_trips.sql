{{ config(materialized='table') }}

WITH fhv_tripdata AS (
    SELECT *,
        'fhv' AS service_type,
        EXTRACT(YEAR FROM pickup_datetime) AS year,
        EXTRACT(MONTH FROM pickup_datetime) AS month
    FROM {{ ref('stg_fhv_tripdata') }}
),
dim_zones AS (
    SELECT * 
    FROM {{ ref('dim_zones') }}
    WHERE borough != 'Unknown'
)
SELECT fhv_tripdata.*,
    pickup_zone.borough as pickup_borough, 
    pickup_zone.zone as pickup_zone, 
    dropoff_zone.borough as dropoff_borough, 
    dropoff_zone.zone as dropoff_zone,
FROM fhv_tripdata
INNER JOIN dim_zones AS pickup_zone
ON fhv_tripdata.PUlocationID = pickup_zone.locationid
INNER JOIN dim_zones AS dropoff_zone
ON fhv_tripdata.DOlocationID = dropoff_zone.locationid