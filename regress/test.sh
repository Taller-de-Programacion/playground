#!/bin/bash

fail() {
    echo "$1"
    exit 1
}

[ $# -eq 1 ] || fail "Usage: $0 <test-name>"
[ -x "./regress/$1.sh" ]   || fail "Test $1 not found."
[ -f "./regress/$1.good" ] || fail "Expected 'good' output for test $1 not found."

sudo "./regress/$1.sh" > "regress/$1.found" 2>&1 ; diff "regress/$1.found" "regress/$1.good"
