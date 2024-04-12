FROM docker.io/bitnami/spark:3.5.0
USER root

# Lib installs and clean up to reduce image size
RUN apt update \
  && apt install -y git \
  && apt install -y g++ \
  && apt install -y nodejs \
  && apt install -y python3-pip \
  && apt-get install -y supervisor \
  && rm -rf /var/lib/apt/lists/*

# Copy the supervisord configuration file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Upgrade pip and install Python packages for data processing and JupyterLab
RUN python -m pip install --upgrade pip
RUN pip3 install jupyterlab
RUN pip3 install py4j

# Set environment variables for Python and Spark integration
ENV PYTHONPATH=$SPARK_HOME/python:$SPARK_HOME/python/lib/py4j-*.zip

# Configure container to open ports used by Spark and JupyterLab
# SparkContext web UI on 4040 -- only available for the duration of the application.
# Spark master’s web UI on 8080.
# Spark worker web UI on 8081.
# Jupyter web UI on 8888.
EXPOSE 4040 8080 8081 8888

# Start a Master-Worker Node and JupyterLab by default
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]



