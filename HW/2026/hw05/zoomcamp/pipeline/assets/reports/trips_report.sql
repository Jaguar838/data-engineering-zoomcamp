/* @bruin

# Docs:
# - SQL assets: https://getbruin.com/docs/bruin/assets/sql
# - Materialization: https://getbruin.com/docs/bruin/assets/materialization
# - Quality checks: https://getbruin.com/docs/bruin/quality/available_checks

# TODO: Set the asset name (recommended: reports.trips_report).
name: reports.trips_report

# TODO: Set platform type.
# Docs: https://getbruin.com/docs/bruin/assets/sql
# suggested type: duckdb.sql
type: duckdb.sql


# TODO: Declare dependency on the staging asset(s) this report reads from.
depends:
  - staging.trips



# TODO: Choose materialization strategy.
# For reports, `time_interval` is a good choice to rebuild only the relevant time window.
# Important: Use the same `incremental_key` as staging (e.g., pickup_datetime) for consistency.
materialization:
  type: table

# TODO: Define report columns + primary key(s) at your chosen level of aggregation.
columns:
  - name: trip_date
    type: date
    description: Дата поездки, агрегированная по дням.
    primary_key: true
  - name: taxi_type
    type: VARCHAR
    description: Тип такси (например, 'yellow' или 'green').
    primary_key: true
  - name: payment_type_name
    type: VARCHAR
    description: Название типа оплаты (например, 'Credit card', 'Cash').
    primary_key: true
  - name: trip_count
    type: BIGINT
    description: Общее количество поездок за день для данного типа такси и типа оплаты.
    checks:
      - name: positive
  - name: total_passengers
    type: BIGINT
    description: Общее количество перевезенных пассажиров за день.
    checks:
      - name: non_negative
  - name: total_distance
    type: DOUBLE
    description: Общее расстояние, пройденное в милях за день.
    checks:
      - name: non_negative
  - name: total_fare
    type: DOUBLE
    description: Общая сумма тарифов за поездки за день.
    checks:
      - name: non_negative
  - name: total_tips
    type: DOUBLE
    description: Общая сумма чаевых за день.
    checks:
      - name: non_negative
  - name: total_revenue
    type: DOUBLE
    description: Общий доход (total_amount) за день.
    checks:
      - name: non_negative
  - name: avg_fare
    type: DOUBLE
    description: Средний тариф за поездку.
  - name: avg_trip_distance
    type: DOUBLE
    description: Среднее расстояние поездки в милях.
  - name: avg_passengers
    type: DOUBLE
    description: Среднее количество пассажиров на поездку.

custom_checks:
  - name: row_count_positive
    description: Ensures the table is not empty
    query: |
      SELECT COUNT(*) > 0 FROM staging.trips
    value: 1

@bruin */


-- Purpose of reports:
-- - Aggregate staging data for dashboards and analytics
-- Required Bruin concepts:
-- - Filter using `{{ start_datetime }}` / `{{ end_datetime }}` for incremental runs
-- - GROUP BY your dimension + date columns

-- Aggregate trips by date, taxi type, and payment type
SELECT
    CAST(pickup_datetime AS DATE) AS trip_date,
    taxi_type,
    payment_type_name,
    -- Count metrics
    COUNT(*) AS trip_count,
    SUM(COALESCE(passenger_count, 0)) AS total_passengers,
    -- Distance metrics
    SUM(COALESCE(trip_distance, 0)) AS total_distance,
    -- Revenue metrics
    SUM(COALESCE(fare_amount, 0)) AS total_fare,
    SUM(COALESCE(tip_amount, 0)) AS total_tips,
    SUM(COALESCE(total_amount, 0)) AS total_revenue,
    -- Average metrics
    AVG(COALESCE(fare_amount, 0)) AS avg_fare,
    AVG(COALESCE(trip_distance, 0)) AS avg_trip_distance,
    AVG(COALESCE(passenger_count, 0)) AS avg_passengers
FROM staging.trips
WHERE pickup_datetime >= '{{ start_date }}'
  AND pickup_datetime < '{{ end_date }}'
GROUP BY
    CAST(pickup_datetime AS DATE),
    taxi_type,
    payment_type_name
