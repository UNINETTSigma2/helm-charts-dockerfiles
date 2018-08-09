#!/bin/bash

# Strict mode
set -euo pipefail

unset SPARK_MASTER_PORT

cores="${SPARK_WORKER_CORES:-1}"
if [[ $cores == *m ]]; then
    cores="${cores/%?/}"
    cores="$((($cores + 999) / 1000))"
fi

# This is to give JAVA process a head start to have master up and running
echo "Waiting for Master: ${SPARK_MASTER_SERVICE_HOST:-spark-master}:${SPARK_MASTER_SERVICE_PORT:-7077}"

if ! `nc.traditional -z -w60 "${SPARK_MASTER_SERVICE_HOST:-spark-master}" "${SPARK_MASTER_SERVICE_PORT:-7077}"`;
then
	echo "Failed in connecting to Master: ${SPARK_MASTER_SERVICE_HOST:-spark-master}, after waiting for 60 secs"
else
	echo "Master: ${SPARK_MASTER_SERVICE_HOST:-spark-master} is up !"
fi


# Run spark-class directly so that when it exits (or crashes), the pod restarts.
$SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker --webui-port 8081 \
	 -c $cores -m ${SPARK_WORKER_MEMORY:-1g} -d ${SPARK_WORKER_DIRS:-/tmp/spark-worker} \
	 "spark://${SPARK_MASTER_SERVICE_HOST:-spark-master}:${SPARK_MASTER_SERVICE_PORT:-7077}"
