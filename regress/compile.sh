#!/bin/bash

# Use a shared 'test' container. If it has already created (cached)
# we will use it directly avoing us to recreate the container again.
IMAGE_NAME=playground:test
docker build -q -t "$IMAGE_NAME" . > /dev/null 2>&1

# Host (local) and container respective sides of the mounted volume
HVOL="$(pwd)/regress"
CVOL="/regress"

echo "Compiling and testing C code"
docker run -i -v "$HVOL:$CVOL:ro" "$IMAGE_NAME" <<EOF
echo "Sizes"
echo "====="

gcc -std=c99 -pedantic -Wall -Werror $CVOL/sizes.c -o sizes
./sizes


echo "Memory"
echo "======"

# disable uninitialized and unused variable warnings for testing purposes
gcc -std=c99 -pedantic -Wall -Werror -Wno-uninitialized -Wno-unused-variable $CVOL/memory.c -o memory
valgrind --leak-check=full -q ./memory 2>&1 | grep 'Invalid\|lost' | sed 's/.*==[0-9]\+== \(.*\)/\1/'

echo "getaddrinfo"
echo "==========="

gcc -std=c99 -pedantic -Wall -Werror $CVOL/getaddrinfo.c -o getaddrinfo
./getaddrinfo
echo "Return code: $?"
EOF
