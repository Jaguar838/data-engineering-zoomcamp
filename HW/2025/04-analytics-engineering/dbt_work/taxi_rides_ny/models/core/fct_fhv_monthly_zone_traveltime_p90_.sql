{{ config(materialized='table') }}

with trips as (
    -- Reference your core model (dim_fhv_trips)
    select *
    from {{ ref('dim_fhv_trips') }}
),
trip_durations as (
    select
        year,
        month,
        pickup_location_id,
        dropoff_location_id,
        -- Compute trip duration in seconds
        TIMESTAMP_DIFF(trips.dropoff_datetime, trips.pickup_datetime, SECOND) as trip_duration
    from trips
)

select
    year,
    month,
    pickup_location_id,
    dropoff_location_id,
    -- APPROX_QUANTILES divides the trip_duration values into 101 buckets.
    -- The element at OFFSET(90) approximates the continuous 90th percentile.
    APPROX_QUANTILES(trip_duration, 100)[OFFSET(90)] as p90_travel_time
from trip_durations
group by year, month, pickup_location_id, dropoff_location_id
order by p90_travel_time desc


{{ config(materialized='table') }}

with trip_durations as (
    -- Reference your core model (dim_fhv_trips)
    select *
    from {{ ref('dim_fhv_trips') }}
),

WITH trip_durations AS (
    SELECT 
        year,
        month,
        pickup_borough,
        pickup_zone,
        dropoff_borough,
        dropoff_zone,
        TIMESTAMP_DIFF(dropoff_datetime, pickup_datetime, SECOND) AS trip_duration
    FROM {{ ref('dim_fhv_trips') }}
    WHERE pickup_datetime IS NOT NULL AND dropoff_datetime IS NOT NULL
),
p90_calculation AS (
    SELECT 
        year,
        month,
        pickup_borough,
        pickup_zone,
        dropoff_borough,
        dropoff_zone,
        APPROX_QUANTILES(trip_duration, 100)[OFFSET(90)] AS trip_duration_p90
    FROM trip_durations
    GROUP BY year, month, pickup_borough, pickup_zone, dropoff_borough, dropoff_zone
)
SELECT 
    year,
    month,
    pickup_borough,
    pickup_zone,
    dropoff_borough,
    dropoff_zone,
    trip_duration_p90
FROM p90_calculation