
## Module 2

## Kestra
* We are using the gree and yellow taxi data from January 2019 to July 2021. Please upload all the needed data into gcs and bigQuery before to solve the quizes.

### Question 1. 
#### Within the execution for Yellow Taxi data for the year 2020 and month 12: what is the uncompressed file size (i.e. the output file yellow_tripdata_2020-12.csv of the extract task)?

I have created a new kestra flow similar to 06_gcp_taxi (where I have deleted all gcs upload, table creation, merge and so on) I let it run until the "extract" task selecting at run time the input variables:
* taxi: yellow
* year: 2020
* month: 12
I execute the flow. After that in "Execution" menu I selected Outputs > extract > outputFile > yellow_tripdata_2020-12.csv, and I have read the size:

Answer:  
```
128.3 MB
```


### Question 2.
#### What is the rendered value of the variable file when the inputs taxi is set to green, year is set to 2020, and month is set to 04 during execution?

The answer can be found looking at the Execution of the flow 06_gcp_taxi_scheduled when it is running the subflow for the green taxi on the date 2020-04. If you look at the labels, one label is ```file:green_tripdata_2020-04.csv`` which is the value of the rendered file variable.  

Answeer:
```
green_tripdata_2020-04.csv
```



### Question 3.
#### How many rows are there for the Yellow Taxi data for all CSV files in the year 2020?

Query in biqQuery:  
```
SELECT
  COUNT(1)
FROM
  `de-zoomcamp2025.dezc2025_bq_dataset.yellow_tripdata`
WHERE filename LIKE '%2020%';
```
Result:  

~~13,537.299~~
<span style="color: red;">24,648,499</span>
~~18,324,219~~
~~29,430,127~~


### Question 4.
####  How many rows are there for the Green Taxi data for all CSV files in the year 2020?

Query in bigQuery:
```
SELECT COUNT(1) 
FROM  `de-zoomcamp2025.dezc2025_bq_dataset.green_tripdata`
WHERE filename LIKE '%2020%';
```

Result:  
~~5,327,301~~
~~936,199~~
<span style="color: red;">1,734,051</span>
~~1,342,034~~


### Question 5.
#### How many rows are there for the Yellow Taxi data for the March 2021 CSV file?

Query in bigQuery:
```
SELECT COUNT(1) 
FROM  `de-zoomcamp2025.dezc2025_bq_dataset.yellow_tripdata`
WHERE filename LIKE '%2021-03%';
```

Result:  
~~1,428,092~~
~~706,911~~
<span style="color: red;">1,925,152</span>
~~2,561,031~~

### Question 6.
#### How would you configure the timezone to New York in a Schedule trigger?
The answer can be found in Kestra documentation:  
https://kestra.io/docs/workflow-components/triggers/schedule-trigger  
Where there is this example:
```
triggers:
  - id: daily
    type: io.kestra.plugin.core.trigger.Schedule
    cron: "@daily"
    timezone: America/New_York
```

Answer:
``` 
Add a timezone property set to America/New_York in the Schedule trigger configuration
```
