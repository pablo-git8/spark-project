# Apache Spark, JupyterLab & Postgres DB Environment Setup

This guide provides instructions on how to set up an Apache Spark environment with JupyterLab using Docker and Docker Compose, including integration with a PostgreSQL database.

## Prerequisites

- Docker ([Docker Desktop](https://www.docker.com/products/docker-desktop/) for Windows)
- Git (if cloning the repository)

## Services Automated

The Dockerfile is configured to automatically execute the Spark master and a single worker node when the container starts, along with a PostgreSQL database.

## Setup Instructions

1. **Clone the Repository** (Skip this step if you already have the files):
   ```bash
   git clone https://github.com/pablo-git8/spark-project.git
   cd spark-project
   ```

2. **Build the Docker Image**:
   Navigate to the directory containing your Dockerfile and run:
   ```bash
   docker-compose build
   ```

3. **Run the Docker Containers**:
   Start the services defined in `docker-compose.yml`:
   ```bash
   docker-compose up -d
   ```

## Automated Spark Services

The command in the Dockerfile is configured to automatically execute the Spark master and a single worker node when the container starts. This allows the Spark master to manage jobs that are executed on the worker node.

## Validation

After the setup, validate the services are running correctly:

1. **Verify Container**:
   Verify your container is created and running by executing the following command. Confirm the status of the container as 'Up':
   ```bash
   docker ps
   ```

2. **Access JupyterLab**:
   Open your web browser and go to [http://localhost:8888/lab](http://localhost:8888/lab). You should see the JupyterLab interface.

3. **Access Spark Master Web UI**:
   Open your web browser and go to [http://localhost:8080](http://localhost:8080). You should see the Apache Spark master's web UI.

4. **Access PostgreSQL Database:**
   Connect to the PostgreSQL database using the credentials specified in the .env file, accessible via SQL clients or notebooks in JupyterLab.

If you are unable to access these interfaces, consult the container logs for troubleshooting:

```bash
docker logs spark-container
```

## Using the Environment

- Your local `./data` directory is mounted to `/data` inside the container for persistent data storage.
- Your local `./notebooks` directory is mounted to `/opt/bitnami/spark/work/notebooks` inside the container, where you can place and manage Jupyter notebooks.
- A PostgreSQL database is available as a service, accessible using the credentials defined in the .env file.

### Connecting to PostgreSQL from JupyterLab
Example Python code snippet in JupyterLab to connect to PostgreSQL:

```python
   import psycopg2

   # Establish a connection
   conn = psycopg2.connect(
      dbname="your_db_name",
      user="your_user",
      password="your_password",
      host="postgres-container"
   )

   cursor = conn.cursor()

   # Remember to close the connection when done
   cursor.close()
   conn.close()
```
Ensure to create a .env in your repository path and include the required PostgreSQL credentials. You can see an example in the .env-ex mock file. **Note:** You may need to copy and paste your .env file inside your jupyter notebook path (depends on how you want to call your credentials).

## Stopping and Cleaning Up

To stop the running services and clean up containers, networks, and volumes, use the following commands:

```bash
# Stop and remove containers and their networks
docker-compose down

# OPTIONAL: To also remove the volumes and images
docker-compose down -v --rmi all

# OPTIONAL: To remove the built Docker image
docker rmi spark-project-spark-jupyter
```

**Warning**: The two last commands will remove all unused volumes and images not associated with running containers. They are optional and should be used with caution.