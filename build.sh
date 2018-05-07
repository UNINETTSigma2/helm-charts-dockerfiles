#!/bin/bash

echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin quay.io

function build_image() {
    img="quay.io/uninett/$1:$2"
    curl -s "https://quay.io/api/v1/repository/uninett/$1/tag/?specificTag=$2" | grep "$2" > /dev/null 2>&1
    if test $? -ne 0
    then
        echo "Building container $img"
        docker build -t $img .

	if [ "$TRAVIS_PULL_REQUEST" != "false" ]; then
	    echo "Skipping push, as this is a pull request"
	    exit 0;
	fi

	if [ "$TRAVIS_BRANCH" != "master" ]; then
	    exit 0;
	fi
        docker push $img
    else
        echo "Skipping, image already exist: $img"
    fi
}

for rawd in $(ls -d */)
do
    directory=$(echo $rawd|sed 's/\///')
    if test -f "$directory/Dockerfile"
    then
        tag="$(git log -n 1 --pretty=format:%cd --date=short -- $directory| sed s/-//g)-$(git log -n 1 --pretty=format:%h -- $directory)"
        cd $directory
        build_image "$directory" "$tag"
        cd ..
    else
        cd $directory
        for innerawd in $(ls -d */)
        do
            innerdir=$(echo $innerawd|sed 's/\///')
            tag="$(git log -n 1 --pretty=format:%cd --date=short -- $innerdir| sed s/-//g)-$(git log -n 1 --pretty=format:%h -- $innerdir)"
            cd $innerdir
            build_image "$directory-$innerdir" "$tag"
            cd ..
        done
        cd ..
    fi
done
