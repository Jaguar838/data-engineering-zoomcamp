{{ config(materialized='view') }}

select 
    service_type, 
    current_revenue_quarter, 
    yoy_revenue_growth_pct 
from
    {{ ref('fct_taxi_trips_quarterly_revenue') }}


WITH trips_filtered AS (
    SELECT
        t.year,
        t.month,
        t.pickup_location_id,
        t.dropoff_location_id,
        t.p90_travel_time,
        dz.zone AS dropoff_zone
    FROM
        trips_table AS t
    JOIN
        dim_zones AS dz
    ON
        t.dropoff_location_id = dz.locationid
    WHERE
        t.year = 2019
        AND t.month = 11
        AND dz.zone IN ('Newark Airport', 'SoHo', 'Yorkville East')
),
ranked_trips AS (
    SELECT
        dropoff_zone,
        p90_travel_time,
        ROW_NUMBER() OVER (
            PARTITION BY dropoff_zone
            ORDER BY p90_travel_time DESC
        ) AS rank
    FROM
        trips_filtered
)
SELECT
    dropoff_zone,
    p90_travel_time
FROM
    ranked_trips
WHERE
    rank = 2;
