{{ config(materialized='view') }}

SELECT *
FROM {{ source('staging', 'fhv_tripdata') }}
where dispatching_base_num is not NULL