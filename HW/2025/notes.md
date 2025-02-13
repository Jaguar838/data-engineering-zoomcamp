# Data Engineering Zoomcamp

Link to Data Engineerin Zoomcamp 2025 playlist: https://www.youtube.com/playlist?list=PL3MmuxUbc_hJed7dXYoJw8DoCuVHhGEQb
Link to homework w2: https://courses.datatalks.club/de-zoomcamp-2025/homework/hw2
Course management: https://courses.datatalks.club/de-zoomcamp-2025/

## Week 1 - Docker

### 1.2.1 Intro to Docker

Why should we care about Docker?
- Local experiments
- Integration tests (CI/CD)
- Reproducibility
- Running pipelines on the cloud (take Docker image and run on AWS Batch, Kubernetes jobs)
- Spark
- Serverless (AWS Lambda, Google functions)

Docker commands:
- `-it` means interactive mode, so you can interact with your Docker container
- `docker run -it --entrypoint=bash python:3.9` to run a python image
- `docker build -t test:pandas .`
    - `.` means it will build it in this directory

### 1.2.2 Ingesting data to Postgres

To setup a Postgres Docker container:
```bash
docker run -it \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_taxi" \
    -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    postgres:13
```

SQLAlchamy is a Python library to deal with SQL. PGAdmin is a web-based GUI tool to interact with Postgres databases.

To setup a PGAdmin Docker container:
```bash
docker run -it \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="root" \
    -p 8080:80 \
    dpage/pgadmin4
```

With a Docker Network we can connect two Docker containers with each other. You can say, this container should run in this network.

To setup this, use:
```bash
docker network create pg-network

docker run -it \
    -e POSTGRES_USER="root" \
    -e POSTGRES_PASSWORD="root" \
    -e POSTGRES_DB="ny_taxi" \
    -v $(pwd)/ny_taxi_postgres_data:/var/lib/postgresql/data \
    -p 5432:5432 \
    --network=pg-network \
    --name pg-database \
    postgres:13
```

### 1.2.3 - Connecting pgAdmin and Postgres

To run PgAdmin in Docker:
```bash
docker run -it \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="root" \
    -p 8080:80 \
    dpage/pgadmin4
```

To run Docker container inside a Docker Network:
```bash
docker run -it \
    -e PGADMIN_DEFAULT_EMAIL="admin@admin.com" \
    -e PGADMIN_DEFAULT_PASSWORD="root" \
    -p 8080:80 \
    --network=pg-network \
    --name pg-admin \
    dpage/pgadmin4
```

### 1.2.4 Dockerizing the Ingestion Script

```bash
python ingest_data.py \
    --user=root \
    --password=root \
    --host=localhost \
    --port=5432 \
    --db=ny_taxi \
    --table_name==yellow_taxi_trips \
    --url=${URL}
```

```
docker build -t taxi_ingest:v001 .
```


```bash
docker run -it \
  --network=pg-network \
    taxi_ingest:v001 \
    --user=root \
    --password=root \
    --host=pg-database \
    --port=5432 \
    --db=ny_taxi \
    --table_name==yellow_taxi_trips \
    --url=${URL}
```

- `${URL}` takes the environment variable URL. To check this run: `echo $URL`. To set a environment variable for the current session, use ` export URL="https://github.com/DataTalksClub/nyc-tlc-data/releases/download/yellow/yellow_tripdata_2019-01.csv.gz"`.
- `it` means interactive mode


`docker-compose up` to run the `docker-compose.yaml` file. 

## WEEK 1 - TERRAFORM

### 1.3.1. TERRAFORM PRIMER

Terraform = an infrastructure as code tool that lets you  define both cloud and on-prem resouces in human-readable configuration files that you can version, reuse and share.

Why use Terraform?
- Simplicity in keeping track of infrastructure (by having human-readbale configuration files)
- Easier collaboration (part of development cycle)
- Reproducibility
- Ensure resources are removed (once you're done you can easily delete resources so you're not charged for it)

What Terraform is not:
- Does not manage and update code on infra
- Does not give you the ability to change immutable resources
- Not used to manage resources not defined in your terraform files

Key Terraform commands:
- Init - Get me the provider I need
- Plan - What am I about to do?
- Apply - Do what is in the tf files (build it)
- Destroy - Remove everything defined in the tf files

LEFT AT VIDEO 1.3.2: Terraform basics

DEADLINE FOR HOMEWORK 2: THURSDAY 6 OF FEBRUARY 00:00

### 1.4.1. Setting up the Environment on Google Cloud

To connect with Google Cloud VM:
- Go to Google Cloud and turn [VM instance](https://console.cloud.google.com/compute/instances?onCreate=true&hl=nl&inv=1&invt=Abo8UQ&project=sandbox-450016) on
- Open iTerm and enter the command: `ssh -i ~/.ssh/gcp lars@34.34.153.74`
    - You are connected with your VM. To check the properties of the VM, use: `htop`
    - The VM already has the Google Cloud SDK (check with: `gcloud --version`)
- The VM is empty. We have to configure it:
    - Download Anaconda: `wget https://repo.anaconda.com/archive/Anaconda3-2024.10-1-Linux-x86_64.sh`
    - Install it with: `bash Anaconda3-2024.10-1-Linux-x86_64.sh`
    - Next, install Docker with: `sudo apt-get install docker.io`
        - To run Docker without `sudo`:
            - `sudo groupadd docker`
            - `sudo gpasswd -a $USER docker`
            - `sudo service docker restart`
            - Logout of the VM
    - Get the course repo: `git clone https://github.com/DataTalksClub/data-engineering-zoomcamp.git`
    - Install docker-compose:
        - Make new directory for executions files: `mkdir bin`
        - Move to new directory: `cd bin`
        - Get latest docker-compose (checkout the repo): `wget https://github.com/docker/compose/releases/download/v2.32.4/docker-compose-linux-x86_64`
        - Make the file executable with: `chmod +x docker-compose`
        - Make it visible from any directory by adding it to the path variable:
            - Open bash startup file: `nano .bashrc`
            - Go to the end and add: `export PATH="${HOME}/bin:${PATH}"`
            - Press Ctrl+O to save it, Enter, and Ctrl-X to exit the screen
    - Install PGcli with `pip install pgcli`
    - Install Terraform in the `bin` directory: `wget https://releases.hashicorp.com/terraform/1.10.5/terraform_1.10.5_linux_386.zip`

Setting a config to connect with the VM:
- Go to the `~/.ssh` folder
- Make a SSH config file with the command: `touch config`
- Open the config file: `code config` and put the following content:

```bash
Host de-zoomcamp
    HostName 130.211.53.124
    User lars
    IdentityFile ~/.ssh/gcp
```

To transfer the `gcs.json` credential file to the VM:
- On your local computer, navigate to the folder in which the `gcs.json` file is located
- Type `sftp de-zoomcamp` to setup a FTP connection
- Type `put gcs.json` to transfer the crendentials file

Setup Google Application credentials in VM:
- Create a new environment variable: `export GOOGLE_APPLICATION_CREDENTIALS=~/.gc/gcs.json`
- Authenticate with GCloud with: `gcloud auth activate-service-account --key-file $GOOGLE_APPLICATION_CREDENTIALS`

Please note: each time you restart your VM, the external IP address changes and has to be updated:
- Go to the `~/.ssh` folder
- Open config with: `code config`
- Change the `HostName` to the new external IP address
- Save file

To close the VM down, you can do it in the terminal with: `sudo shutdown now`

Now, when you type: `ssh de-zoomcamp` it uses the identifyfile specified above to connect with your VM.

To connect VS code with your VM:
- Press Ctrl-Command-P and type `>Remove-SSH: Connect to host`
- Select `de-zoomcamp`

Usefull commands in Ubuntu VM:
- `less .bashrc` - To watch the startup file the VM runs when it starts up
- `logout` - To logout of your VM (ctrl-D)
- `sudo apt-get update` - To fetch the latest packages
- `mkdir bin` - To create a folder with all the executable files
- `-O` - Flag to specify the output name
- `chmod +x docker-compose` - To give the docker-compose execution permissions (green means its executable)

## WEEK 2 - Workflow Orchestration

### 2.2.1 - Workflow Orchestration Introduction

What is Kestra?
- All-in-one orchestration platform
- ETL / API orchestration / scheduled & event-driven workflows / batch data pipelines
- Options for no code, low code or full code
- Mutiple programming languages
- Monitor all your workflows and executions

What we cover:
- Introduction to Kestra
- ETL: Extra data and load it to Postgress
- ETL: Extra data and load it to Google Cloud
- Parameterizing Execution
- Scheduling and backfills

dbt = data build tool

## WEEK 3 - Data Warehouse

OLTP = OnLine Transaction Processing
OLAP = OnLine Analytical Processing

Data warehouse is a OLAP solution. 

BigQuery (BQ):
- Serverless data warehouse
    - There are no servers to manage or database software to install
- Software as well as infrastructure including
    - Scalability and high-availability
- Many build-in features like:
    - ML
    - Geospatial analysis
    - Business intelligence
- Includes public datasets

Partions in BQ:
- On columns:
    - Time-unit column
    - Ingestion time
    - Integer range partitioning
- To make not a full scan over the table when quering it
- Only possible on 1 column
- Number of partitions limit is 4000

Clustering in BQ:
- Columns you specify are used to colocate related data
- Order of column is important
- Clustering improves:
    - Filter queries
    - Aggregate queries
- Table with data size less then 1GB don't show improvement with partitioning of clustering
- You can specify up to four clustering columns
- Clustering columns must be top-level, non repeated columns

Clustering over paritioning: use clustering when...
- Partitioning results in small partitions (less then 1GB)
- Partitioning results in more then 4000 different partitions
- Partitioning results in your mutation operations modifying the majority of partitions in the table frequently (e.g. every few minutes all partitions have to be updated)

BQ best practices:
For cost reduction:
- Avoid `SELECT *` (specify the columns instead)
- Price your queries before running them
- Use clustered or partitioned tables
- Use streaming inserts with caution (they can increase your cost)
- Materialize query results in stages
For query performance:
- Filter on partioned columns
- Denormalizing data
- Use nested or repeated columns
- Use external data sources appropiately
    - Don't use it, in case you want a high query performance
- Reduce data before using `JOIN`
- Do not treat `WITH` clauses as prepared statements
- Avoid oversharing tables
- Avoid JavaScript user-defined functions
- Use approximate aggregation functions
- Order statement should be at the end of the query
- Optimize your join patterns
- Place the largest table first, followed by the table with the fewest rows, and then place the remaining tables by decreasing size
    - Reason: the first table gets distributed evently, the second table would be broadcasted to all the nodes

BQ uses column-oriented storage. The reason BigQuery is so fast is because it divides the query into smaller chunks that can be distrited on different (leaf) nodes.