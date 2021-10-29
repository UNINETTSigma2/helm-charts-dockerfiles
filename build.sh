#!/bin/bash


#echo "$DOCKER_PASSWORD" | docker login --username "$DOCKER_USERNAME" --password-stdin quay.io

function build_image() {
    img="quay.io/nird-toolkit/$1:$2"
    curl -s "https://quay.io/api/v1/repository/nird-toolkit/$1/tag/?specificTag=$2" | grep "$2" > /dev/null 2>&1
    if test $? -ne 0
    then
	echo "Building container $img"
	PKG_VERSIONS=$(grep -o "PKG_.*=\S*" Dockerfile | tr "_" "-" | tr '[:upper:]' '[:lower:]')
	MAYBE_ARGS=""

	for v in $PKG_VERSIONS
	do
	    MAYBE_ARGS="--label $v $MAYBE_ARGS"
	done

	docker build $MAYBE_ARGS --cache-from="quay.io/nird-toolkit/$1:$3" -t $img .

	
	docker push $img
	docker rmi $img
    else
        echo "Skipping, image already exist: $img"
    fi
}

for rawd in $(ls -d desk*/)
do
    directory=$(echo $rawd|sed 's/\///')
    if test -f "$directory/Dockerfile"
    then
        tag="$(git log -n 1 --pretty=format:%cd --date=short -- $directory| sed s/-//g)-$(git log -n 1 --pretty=format:%h -- $directory)"
        tag_prev="$(git log --skip 1 -n 1 --pretty=format:%cd --date=short -- $directory| sed s/-//g)-$(git log --skip 1 -n 1 --pretty=format:%h -- $directory)"
        cd $directory
        build_image "$directory" "$tag" "$tag_prev"
        cd ..
    else
        cd $directory
        for innerawd in $(ls -d */)
        do
            innerdir=$(echo $innerawd|sed 's/\///')
            tag="$(git log -n 1 --pretty=format:%cd --date=short -- $innerdir| sed s/-//g)-$(git log -n 1 --pretty=format:%h -- $innerdir)"
            tag_prev="$(git log --skip 1 -n 1 --pretty=format:%cd --date=short -- $innerdir| sed s/-//g)-$(git log --skip 1 -n 1 --pretty=format:%h -- $innerdir)"
            cd $innerdir
            build_image "$directory-$innerdir" "$tag" "$tag_prev"
            cd ..
        done
        cd ..
    fi
done
