#!/bin/bash

# Strict mode
set -euo pipefail

unset SPARK_MASTER_PORT

core_limit="${SPARK_WORKER_CORES:-1}"
if [[ $core_limit == *m ]]; then
    core_limit="${core_limit/%?/}"
    core_limit="$((($core_limit + 999) / 1000))"
fi

mem="${SPARK_WORKER_MEMORY:-1g}"
read daemon_mem executor_mem < <(mem_parser.py $mem 0.4 1000M)

# This is to give JAVA process a head start to have master up and running
echo "Waiting for Master: ${SPARK_MASTER_SERVICE_HOST:-spark-master}:${SPARK_MASTER_SERVICE_PORT:-7077}"

# Do infinite loop as k8s will killus if master is not up anyway
while true
do
	if ! `nc.traditional -z -w5 "${SPARK_MASTER_SERVICE_HOST:-spark-master}" "${SPARK_MASTER_SERVICE_PORT:-7077}"`;
	then
		echo "Master: ${SPARK_MASTER_SERVICE_HOST:-spark-master} is not up. I am early, retrying.."
	else
		echo "Master: ${SPARK_MASTER_SERVICE_HOST:-spark-master} is up !"
		break
	fi
done
export SPARK_DAEMON_JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseContainerSupport -XX:ParallelGCThreads=${core_limit} -XX:ConcGCThreads=${core_limit} -Djava.util.concurrent.ForkJoinPool.common.parallelism=${core_limit}"

export SPARK_DAEMON_MEMORY="$daemon_mem"
# Run spark-class directly so that when it exits (or crashes), the pod restarts.
$SPARK_HOME/bin/spark-class org.apache.spark.deploy.worker.Worker --webui-port 8081 \
	 -c $core_limit -m $executor_mem -d ${SPARK_WORKER_DIRS:-/tmp/spark-worker} \
	 "spark://${SPARK_MASTER_SERVICE_HOST:-spark-master}:${SPARK_MASTER_SERVICE_PORT:-7077}"
