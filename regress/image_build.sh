#!/bin/bash

IMAGE_NAME=playground:image_build_test
MAX_SIZE=350

# clean up
docker rmi --force "$IMAGE_NAME" 2>/dev/null 1>&2

echo "Build the playground image from a directory."
docker build --no-cache -q -t "$IMAGE_NAME" . > /dev/null 2>&1

echo -n "Does the image exist? "
docker images --format="Yes." "$IMAGE_NAME"

echo -n "Is the image too big? "
SIZE=$(docker images --format="{{.Size}}" "$IMAGE_NAME" | sed 's/\([0-9]\+\).*/\1/')
if [ "$SIZE" -gt "$MAX_SIZE" ] 
then
    echo "Yes it is too big: $SIZE"
else
    echo "No, it is OK."
fi

echo "Check toolchain"
docker run -i "$IMAGE_NAME" <<EOF
command -V gcc
command -V g++
command -V valgrind
EOF

echo "Check toolchain versions"
docker run -i "$IMAGE_NAME" <<EOF
gcc --version   | head -n 1
g++ --version   | head -n 1
valgrind --version   | head -n 1
EOF


# clean up
docker rmi --force "$IMAGE_NAME" 2>/dev/null 1>&2
