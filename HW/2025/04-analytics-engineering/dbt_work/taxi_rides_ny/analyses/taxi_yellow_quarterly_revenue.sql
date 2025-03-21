{{ config(materialized='view') }}

select 
    service_type, 
    current_revenue_quarter, 
    yoy_revenue_growth_pct 
from
    {{ ref('fct_taxi_trips_quarterly_revenue') }}
    
where
    service_type = 'yellow'
    AND year = 2020
