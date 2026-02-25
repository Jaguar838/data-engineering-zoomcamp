/* @bruin

# Docs:
# - Materialization: https://getbruin.com/docs/bruin/assets/materialization
# - Quality checks (built-ins): https://getbruin.com/docs/bruin/quality/available_checks
# - Custom checks: https://getbruin.com/docs/bruin/quality/custom

# TODO: Set the asset name (recommended: staging.trips).
name: staging.trips
# TODO: Set platform type.
# Docs: https://getbruin.com/docs/bruin/assets/sql
# suggested type: duckdb.sql
type: duckdb.sql

# TODO: Declare dependencies so `bruin run ... --downstream` and lineage work.
# Examples:
# depends:
#   - ingestion.trips
#   - ingestion.payment_lookup
depends:
   - ingestion.trips
   - ingestion.payment_lookup

# TODO: Choose time-based incremental processing if the dataset is naturally time-windowed.
# - This module expects you to use `time_interval` to reprocess only the requested window.
materialization:
  # What is materialization?
  # Materialization tells Bruin how to turn your SELECT query into a persisted dataset.
  # Docs: https://getbruin.com/docs/bruin/assets/materialization
  #
  # Materialization "type":
  # - table: persisted table
  # - view: persisted view (if the platform supports it)
  type: table

  columns:
  
    - name: pickup_datetime
      type: TIMESTAMP
      description: Дата й час, коли лічильник було увімкнено.
      primary_key: true
      nullable: false
    - name: dropoff_datetime
      type: TIMESTAMP
      description: Дата й час, коли лічильник було вимкнено.
      primary_key: true
      nullable: false
    - name: pickup_location_id
      type: INTEGER
      description: Зона таксі TLC, у якій було увімкнено таксометр.
      primary_key: true
      nullable: false
    - name: dropoff_location_id
      type: INTEGER
      description: Зона таксі TLC, у якій було вимкнено таксометр.
      primary_key: true
      nullable: false
    - name: taxi_type
      type: VARCHAR
      description: Тип таксі (жовте або зелене).
      checks:
        - name: not_null
        - name: accepted_values
          value: ['yellow', 'green']
    - name: passenger_count
      type: DOUBLE
      description: Кількість пасажирів у транспортному засобі.
    - name: trip_distance
      type: DOUBLE
      description: Пройдена відстань поїздки в милях, повідомлена таксометром.
    - name: payment_type
      type: DOUBLE
      description: Числовий код, що позначає, як пасажир оплатив поїздку.
    - name: payment_type_name
      type: VARCHAR
      description: Зрозумілий для людини опис типу оплати.
    - name: fare_amount
      type: DOUBLE
      description: Тариф за час і відстань, розрахований лічильником.
    - name: extra
      type: DOUBLE
      description: Miscellaneous extras and surcharges.
    - name: mta_tax
      type: DOUBLE
      description: MTA tax.
    - name: tip_amount
      type: DOUBLE
      description: Сума чайових (автоматично заповнюється для чайових з кредитної картки, вводиться вручну для чайових готівкою).
    - name: tolls_amount
      type: DOUBLE
      description: Total amount of all tolls paid in trip.
    - name: improvement_surcharge
      type: DOUBLE
      description: Improvement surcharge.
    - name: total_amount
      type: DOUBLE
      description: Загальна сума, стягнена з пасажирів (не включає чайові готівкою).
    - name: extracted_at
      type: TIMESTAMP
      description: Часова мітка, коли дані були витягнуті з джерела.


# TODO: Add one custom check that validates a staging invariant (uniqueness, ranges, etc.)
# Docs: https://getbruin.com/docs/bruin/quality/custom
custom_checks:
  - name: row_count_positive
    description: Ensures the table is not empty
    query: |
      SELECT COUNT(*) > 0 FROM staging.trips
    value: 1

@bruin */

-- TODO: Write the staging SELECT query.
--
-- Purpose of staging:
-- - Clean and normalize schema from ingestion
-- - Deduplicate records (important if ingestion uses append strategy)
-- - Enrich with lookup tables (JOINs)
-- - Filter invalid rows (null PKs, negative values, etc.)
--
-- Why filter by {{ start_datetime }} / {{ end_datetime }}?
-- When using `time_interval` strategy, Bruin:
--   1. DELETES rows where `incremental_key` falls within the run's time window
--   2. INSERTS the result of your query
-- Therefore, your query MUST filter to the same time window so only that subset is inserted.
-- If you don't filter, you'll insert ALL data but only delete the window's data = duplicates.

WITH source_data AS (
    SELECT
        -- (Предположительно здесь перечисляются все столбцы из pic_2)
        lpep_pickup_datetime AS pickup_datetime,
        lpep_dropoff_datetime AS dropoff_datetime,
        PULocationID AS pickup_location_id,
        DOLocationID AS dropoff_location_id,
        taxi_type,
        passenger_count,
        trip_distance,
        payment_type,
        fare_amount,
        extra,
        mta_tax,
        tip_amount,
        tolls_amount,
        improvement_surcharge,
        total_amount,
        -- Metadata
        extracted_at
    FROM ingestion.trips
    WHERE 1=1
        -- Filter out invalid records
        AND lpep_pickup_datetime IS NOT NULL
        AND fare_amount >= 0
        AND total_amount >= 0
),

-- Deduplicate using composite key
deduplicated AS (
    SELECT
        *,
        ROW_NUMBER() OVER (
            PARTITION BY
                pickup_datetime,
                dropoff_datetime,
                pickup_location_id,
                dropoff_location_id,
                fare_amount
            ORDER BY extracted_at DESC
        ) AS row_num
    FROM source_data
)

-- Final select with payment lookup enrichment
SELECT
    d.pickup_datetime,
    d.dropoff_datetime,
    d.pickup_location_id,
    d.dropoff_location_id,
    d.taxi_type,
    d.passenger_count,
    d.trip_distance,
    d.payment_type,
    COALESCE(p.payment_description, 'unknown') AS payment_type_name,
    d.fare_amount,
    d.extra,
    d.mta_tax,
    d.tip_amount,
    d.tolls_amount,
    d.improvement_surcharge,
    d.total_amount,
    d.extracted_at
FROM deduplicated d
LEFT JOIN ingestion.payment_lookup p
    ON d.payment_type = p.payment_type_id
WHERE d.row_num = 1;