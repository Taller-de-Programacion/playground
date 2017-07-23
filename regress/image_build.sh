#!/bin/bash

IMAGE_NAME=playground:test
MAX_SIZE=150

docker rmi --force  playground:test 2>/dev/null 1>&2

echo "Build the playground image from a directory."
( set -x ; docker build --no-cache -q -t "$IMAGE_NAME" . ) > /dev/null

echo -n "Does the image exist? "
docker images --format="{{.Repository}} found" "$IMAGE_NAME"

SIZE=$(docker images --format="{{.Size}}" "$IMAGE_NAME" | sed 's/\([0-9]\+\).*/\1/')
if [ "$SIZE" -gt "$MAX_SIZE" ] 
then
    echo "Image's size is too large: $SIZE"
else
    echo "Image's size is ok."
fi




docker rmi --force  playground:test 2>/dev/null 1>&2 
