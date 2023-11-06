#!/bin/bash

# Strict mode
set -euo pipefail

echo "spark.deploy.recoveryDirectory ${SPARK_RECOVERY_DIR:-/tmp/spark-master}" >> $SPARK_HOME/conf/spark-defaults.conf
echo "spark.ui.reverseProxyUrl  https://${SPARK_PUBLIC_DNS}" >> $SPARK_HOME/conf/spark-defaults.conf
echo "spark.master spark://$${HOSTNAME}.${RELEASE_NAMESPACE}.svc.cluster.local:7077 " >> $SPARK_HOME/conf/spark-defaults.conf

core_limit="${SPARK_DAEMON_CORES:-1}"
if [[ $core_limit == *m ]]; then
    core_limit="${core_limit/%?/}"
    core_limit="$((($core_limit + 999) / 1000))"
fi

unset SPARK_MASTER_PORT
export SPARK_DAEMON_JAVA_OPTS="-XX:+UnlockExperimentalVMOptions -XX:+UseContainerSupport -XX:ParallelGCThreads=${core_limit} -XX:ConcGCThreads=${core_limit} -Djava.util.concurrent.ForkJoinPool.common.parallelism=${core_limit}"

# Run spark-class directly so that when it exits (or crashes), the pod restarts.
$SPARK_HOME/bin/spark-class org.apache.spark.deploy.master.Master --webui-port 8080
