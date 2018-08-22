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
else
	echo "spark.master ${SPARK_MASTER_SERVICE}" >> $SPARK_HOME/conf/spark-defaults.conf
	export SPARK_OPTS="--master=${SPARK_MASTER_SERVICE}"
fi

echo "spark.driver.memory ${SPARK_DRIVER_MEMORY:-1g}" >> $SPARK_HOME/conf/spark-defaults.conf
echo "spark.driver.cores ${SPARK_DRIVER_CORES:-1}" >> $SPARK_HOME/conf/spark-defaults.conf
echo "spark.driver.host `hostname -i`" >> $SPARK_HOME/conf/spark-defaults.conf


# If we have shared data mounted, the link it to current directory to have it visible in notebook
if [ -d "$PVC_MOUNT_PATH" ] && [ ! -L "$HOME/data" ]; then
	ln -s "$PVC_MOUNT_PATH" "$HOME/data"
fi

# If we don't have the .jupyter config then copy it to user directory
if [ ! -d "$HOME/.jupyter/nbconfig" ]; then
	cp -r /home/notebook/.jupyter/nbconfig $HOME/.jupyter/
fi

if [[ ! -z "${JUPYTER_ENABLE_LAB}" ]]; then
	jupyter lab --config $HOME/.jupyter/notebook_config.py $* &
else
	jupyter notebook --config $HOME/.jupyter/notebook_config.py $* &
fi

sleep inf