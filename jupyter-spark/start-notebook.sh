#!/bin/bash

set -e

# Exec the specified command or fall back on bash
if [ $# -eq 0 ]; then
    cmd=bash
else
    cmd=$*
fi

if [ -z ${SPARK_MASTER_SERVICE+x} ]; then
	echo "spark.master local[1]" >> $SPARK_HOME/conf/spark-defaults.conf
	echo "spark.eventLog.dir  file:///tmp" >> $SPARK_HOME/conf/spark-defaults.conf
else
	echo "spark.master ${SPARK_MASTER_SERVICE}" >> $SPARK_HOME/conf/spark-defaults.conf
	export SPARK_OPTS="--master=${SPARK_MASTER_SERVICE}"
	if [[ $SPARK_MASTER_SERVICE == spark* ]]; then
		echo "spark.eventLog.dir  file://${SPARK_EVENTLOG_DIR}/${SPARK_MASTER_SERVICE:8:-12}/events" >> $SPARK_HOME/conf/spark-defaults.conf
	else
		echo "spark.eventLog.dir  file:///tmp" >> $SPARK_HOME/conf/spark-defaults.conf
	fi
fi

echo "spark.driver.memory ${SPARK_DRIVER_MEMORY:-1g}" >> $SPARK_HOME/conf/spark-defaults.conf
echo "spark.driver.cores ${SPARK_DRIVER_CORES:-1}" >> $SPARK_HOME/conf/spark-defaults.conf
echo "spark.driver.host `ifconfig eth0 | awk '/inet addr/{print substr($2,6)}'`" >> $SPARK_HOME/conf/spark-defaults.conf

if [[ ! -z "${JUPYTER_ENABLE_LAB}" ]]; then
	jupyter lab --config $HOME/.jupyter/notebook_config.py $* &
else
	jupyter notebook --config $HOME/.jupyter/notebook_config.py $* &
fi

sleep inf