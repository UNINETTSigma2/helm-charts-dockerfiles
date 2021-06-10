#!/bin/bash
STRING=`find -name Dockerfile`
PATHS_TO_DOCKERFILE=($STRING)
echo '{ "dockerfiles" : ['
for path in ${PATHS_TO_DOCKERFILE[@]};
do
    if [[ $path == ${PATHS_TO_DOCKERFILE[-1]} ]];
    then
	echo "\"$path\""
    else
	echo "\"$path\","
    fi
done
echo "]}"
