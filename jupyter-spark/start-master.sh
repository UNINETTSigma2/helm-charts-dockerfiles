#!/bin/bash

# Strict mode
set -euo pipefail

echo "spark.deploy.recoveryDirectory ${SPARK_RECOVERY_DIR:-/tmp}" >> $SPARK_HOME/conf/spark-defaults.conf
echo "spark.ui.reverseProxyUrl  https://${SPARK_PUBLIC_DNS}" >> $SPARK_HOME/conf/spark-defaults.conf
echo "spark.eventLog.dir  file://${SPARK_EVENTLOG_DIR}" >> $SPARK_HOME/conf/spark-defaults.conf

unset SPARK_MASTER_PORT

# Run spark-class directly so that when it exits (or crashes), the pod restarts.
$SPARK_HOME/bin/spark-class org.apache.spark.deploy.master.Master --webui-port 8080
