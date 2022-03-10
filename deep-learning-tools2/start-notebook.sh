#!/bin/bash

set -e

if [ -z ${SPARK_MASTER_SERVICE+x} ]; then
	echo "spark.master local[1]" >> $SPARK_HOME/conf/spark-defaults.conf
else
	echo "spark.master ${SPARK_MASTER_SERVICE}" >> $SPARK_HOME/conf/spark-defaults.conf
	export SPARK_OPTS="--master=${SPARK_MASTER_SERVICE}"
fi

echo "spark.driver.memory ${SPARK_DRIVER_MEMORY:-1g}" >> "$SPARK_HOME/conf/spark-defaults.conf"
echo "spark.driver.cores ${SPARK_DRIVER_CORES:-1}" >> "$SPARK_HOME/conf/spark-defaults.conf"
echo "spark.driver.host $(hostname -i)" >> "$SPARK_HOME/conf/spark-defaults.conf"

# If we have shared data mounted, the link it to current directory to have it visible in notebook
if [ -d "$PVC_MOUNT_PATH" ] && [ ! -L "$HOME/data" ]; then
	ln -s "$PVC_MOUNT_PATH" "$HOME/data"
fi

# If we don't have the .jupyter config then copy it to user directory
if [ ! -d "$HOME/.jupyter/nbconfig" ]; then
	cp -r /etc/default/jupyter/nbconfig "$HOME/.jupyter/"
fi

# Make Tensorflow default backend for keras, if user doesn't already have .keras file
if [ ! -d "$HOME/.keras" ]; then
    mkdir -p "$HOME/.keras"
    echo -e '{\n"image_data_format": "channels_last",\n"epsilon": 1e-07,\n"floatx": "float32",\n"backend": "tensorflow"\n}' > "$HOME/.keras/keras.json"
fi

if [[ ! -z "${JUPYTER_ENABLE_LAB}" ]]; then
	if [[ ! -z "${JUPYTER_HUB}" ]]; then
		jupyter-labhub $* &
	else
		jupyter lab --config "$HOME/.jupyter/notebook_config.py" $* &
	fi
else
	if [[ ! -z "${JUPYTER_HUB}" ]]; then
		jupyterhub-singleuser $* &
	else
		jupyter notebook --config "$HOME/.jupyter/notebook_config.py" $* &
	fi
fi

tensorboard --logdir="$TENSORBOARD_LOGDIR" --port=6006 &
mlflow server --backend-store-uri "sqlite:///$MLFLOW_DATADIR/mlflow.db" --host 0.0.0.0 &
export MLFLOW_TRACKING_URI="http://localhost:5000"

sleep inf
