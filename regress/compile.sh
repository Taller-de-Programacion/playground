#!/bin/bash

# Use a shared 'test' container. If it has already created (cached)
# we will use it directly avoing us to recreate the container again.
docker-compose -f docker-compose-files/for_test.yml  build  > /dev/null 2>&1

# Path to the sources from the point of view of the container
CVOL="/regress"

echo "Compiling and testing C code"
docker-compose -f docker-compose-files/for_test.yml  run  test <<EOF
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

echo
echo "Compiling and testing C++ code"
docker-compose -f docker-compose-files/for_test.yml  run  test <<EOF
echo "Sizes"
echo "====="

g++ -std=c++11 -pedantic -Wall -Werror $CVOL/sizes.c -o sizes
./sizes


echo "Memory"
echo "======"

# disable uninitialized and unused variable warnings for testing purposes
g++ -std=c++11 -pedantic -Wall -Werror -Wno-uninitialized -Wno-unused-variable $CVOL/memory.c -o memory
valgrind --leak-check=full -q ./memory 2>&1 | grep 'Invalid\|lost' | sed 's/.*==[0-9]\+== \(.*\)/\1/'

echo "Threads"
echo "======="

g++ -std=c++11 -pedantic -Wall -Werror -pthread $CVOL/threads.cpp -o threads
./threads

echo "Algorithms and templates"
echo "========================"

g++ -std=c++11 -pedantic -Wall -Werror $CVOL/algorithm.cpp -o algorithm
./algorithm

EOF
