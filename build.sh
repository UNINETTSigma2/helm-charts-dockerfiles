#!/bin/bash

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin quay.io

for rawd in $(ls -d */)
do
    d=$(echo $rawd|sed 's/\///')
    if test $d == "spark"
    then
        continue
        # Skip spark image for now, need to fix the directory structure
    fi
    tag="$(git log -n 1 --pretty=format:%cd --date=short -- $d| sed s/-//g)-$(git log -n 1 --pretty=format:%h -- $d)"
    img="quay.io/uninett/$d:$tag"
    curl -s "https://quay.io/api/v1/repository/uninett/$d/tag/?specificTag=$tag" | grep "$tag" > /dev/null 2>&1
    if test $? -ne 0
    then
        cd $d
        echo "Building container $img"
        docker build -t $img .
        docker push $img
        cd ..
    else
        echo "Skipping, image already exist: $img"
    fi
done