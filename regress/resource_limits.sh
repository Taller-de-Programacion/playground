#!/bin/bash

docker-compose -f compose.yml  build  > /dev/null 2>&1

# Path to the sources from the point of view of the container
CVOL="/regress"

echo "Testing the limits for compile service"
docker-compose -f compose.yml run --rm compile <<EOF
echo "Memory"
echo "======"

gcc -std=c99 -pedantic -Wall -Werror $CVOL/memory.c -o memory
./memory 500    # allocate 500 MB, it should be ok
./memory 700    # allocate 700 MB, it should be *not* ok

EOF

