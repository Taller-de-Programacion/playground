#!/bin/bash

# Build the image. If it is already created (cached), using it.
docker-compose -f compose.yml  build  > /dev/null 2>&1

# Path to the sources from the point of view of the container
CVOL="/regress"

echo "Compiling and testing C code"
docker-compose -f compose.yml run compile <<EOF
echo "Sizes"
echo "====="

gcc -std=c99 -pedantic -Wall -Werror $CVOL/sizes.c -o sizes
./sizes


echo "Memory"
echo "======"

# disable uninitialized and unused variable warnings for testing purposes
gcc -std=c99 -pedantic -Wall -Werror -Wno-uninitialized -Wno-unused-variable $CVOL/bad_memory.c -o bad_memory
valgrind --leak-check=full -q ./bad_memory 2>&1 | grep 'Invalid\|lost' | sed 's/.*==[0-9]\+== \(.*\)/\1/'

echo "getaddrinfo"
echo "==========="

gcc -std=c99 -pedantic -Wall -Werror $CVOL/getaddrinfo.c -o getaddrinfo
./getaddrinfo
echo "Return code: $?"
EOF

echo
echo "Compiling and testing C++ code"
docker-compose -f compose.yml run compile <<EOF
echo "Sizes"
echo "====="

g++ -std=c++11 -pedantic -Wall -Werror $CVOL/sizes.c -o sizes
./sizes


echo "Memory"
echo "======"

# disable uninitialized and unused variable warnings for testing purposes
g++ -std=c++11 -pedantic -Wall -Werror -Wno-uninitialized -Wno-unused-variable $CVOL/bad_memory.c -o bad_memory
valgrind --leak-check=full -q ./bad_memory 2>&1 | grep 'Invalid\|lost' | sed 's/.*==[0-9]\+== \(.*\)/\1/'

echo "Threads"
echo "======="

g++ -std=c++11 -pedantic -Wall -Werror -pthread $CVOL/threads.cpp -o threads
./threads

echo "Algorithms and templates"
echo "========================"

g++ -std=c++11 -pedantic -Wall -Werror $CVOL/algorithm.cpp -o algorithm
./algorithm

EOF
