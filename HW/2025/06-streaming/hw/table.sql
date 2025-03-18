--processed_events
SELECT COUNT(1) FROM processed_events;

SELECT * FROM processed_events LIMIT 50;

CREATE TABLE IF NOT EXISTS processed_events (
 test_data integer,
 event_timestamp timestamp
);

--processed_events_aggregated
SELECT COUNT(1) FROM processed_events_aggregated;

SELECT * FROM processed_events_aggregated LIMIT 50;

 CREATE TABLE processed_events_aggregated (
 event_hour TIMESTAMP(3),
 test_data INT,
 num_hits BIGINT,
 PRIMARY KEY (event_hour, test_data)
 );

--processed_taxi_events
SELECT COUNT(1) FROM processed_taxi_events;

SELECT * FROM processed_taxi_events LIMIT 50;

CREATE TABLE processed_taxi_events (
lpep_pickup_datetime VARCHAR,
lpep_dropoff_datetime VARCHAR,
PULocationID INTEGER,
DOLocationID INTEGER,
passenger_count DOUBLE PRECISION,
trip_distance DOUBLE PRECISION,
tip_amount DOUBLE PRECISION
);

--processed_taxi_events_aggregated
SELECT COUNT(1) FROM processed_taxi_events_aggregated;

SELECT * FROM processed_taxi_events_aggregated LIMIT 50;

 CREATE TABLE processed_taxi_events_aggregated (
 event_hour TIMESTAMP(3),
 PULocationID INTEGER,
 DOLocationID INTEGER,
 max_trip_duration VARCHAR,
 num_trips INTEGER,
 PRIMARY KEY (PULocationID, DOLocationID)
 );