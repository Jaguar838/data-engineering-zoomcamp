-- QUESTION 1. Подсчет записей
-- Використовуємо створену зовнішню таблицю
select count(VendorID) from `trips_data_yellow.yellow_tripdata_2024_external`;

-- QUESTION 2. Оценка считанных данных
-- Зовнішня таблиця (external table query)
select count(distinct VendorID) from `trips_data_yellow.yellow_tripdata_2024_external`;
-- Примітка: обробка зазвичай займає 0 B для зовнішніх таблиць у метаданих, але залежить від формату.

-- Створюємо внутрішню табл.
CREATE OR REPLACE TABLE `trips_data_yellow.yellow_tripdata_2024_internal` AS
SELECT * FROM `trips_data_yellow.yellow_tripdata_2024_external`;

-- Внутрішня таблиця (internal table query) - припускаючи, що ви створите її з зовнішньої
select count(distinct VendorID) from `trips_data_yellow.yellow_tripdata_2024_internal`;

-- QUESTION 3. Понимание столбчатой ​​структуры хранения
select PULocationID from `trips_data_yellow.yellow_tripdata_2024_internal`;
select PULocationID, DOLocationID from `trips_data_yellow.yellow_tripdata_2024_internal`;

-- QUESTION 4. Подсчет поездок с нулевым тарифом 
select count(VendorID) from `trips_data_yellow.yellow_tripdata_2024_external` where fare_amount=0;

-- QUESTION 5. Разделение и кластеризация
CREATE OR REPLACE TABLE `trips_data_yellow.yellow_tripdata_2024_part_datetime`
PARTITION BY
  DATE(tpep_pickup_datetime) 
CLUSTER BY 
  VendorID
AS (SELECT * FROM `trips_data_yellow.yellow_tripdata_2024_internal`);

-- QUESTION 6. Выгоды от раздела имущества
-- Запит до непарційованої таблиці
select count(distinct VendorID) from `trips_data_yellow.yellow_tripdata_2024_internal` 
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';

-- Запит до парційованої таблиці
select count(distinct VendorID) from `trips_data_yellow.yellow_tripdata_2024_part_datetime` 
WHERE tpep_dropoff_datetime BETWEEN '2024-03-01' AND '2024-03-15';
-- QUESTION 7. Внешнее хранилище на
GCP Bucket

-- QUESTION 8. Передовые методы кластеризации
В Big Query рекомендуется всегда кластеризовать данные:
FALSE

-- QUESTION 9
select count(*) from `trips_data_yellow.yellow_tripdata_2024_part_datetime`;
Це може здатися дивним, але BigQuery обробить цей запит без сканування рядків у таблиці з наступних причин:

Метадані таблиці: Для операції count(*) BigQuery не потрібно читати вміст кожної колонки. Він просто бере вже готове число із заздалегідь підрахованих метаданих таблиці, які оновлюються під час кожного завантаження даних.


Особливість внутрішніх таблиць: На відміну від зовнішніх таблиць (де BigQuery доводиться відкривати Parquet-файли, щоб порахувати рядки), у матеріалізованих таблицях ця статистика зберігається в керуючому шарі BigQuery.


Колонкове зберігання: Навіть якщо б ви рахували конкретну колонку (наприклад, count(VendorID)), BigQuery прочитав би лише цю одну колонку, а не весь рядок, що все одно було б набагато менше за загальний обсяг таблиці.

Важливо: Якщо ви додасте умову WHERE (наприклад, WHERE VendorID = 1), BigQuery вже не зможе використати лише метадані й почне сканувати конкретні дані, але завдяки вашому партиціюванню та кластеризації обсяг все одно буде мінімальним.
