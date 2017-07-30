#!/bin/bash

fail() {
    echo "$1"
    exit 1
}

if [ $# -eq 2 ] 
then
    action="$1"
    t="$2"
elif [ $# -eq 1 ]
then
    action="run"
    t="$1"
else
    fail "Usage: $0 <test-name>"
fi

[ "$action" == "run" -o "$action" == "meld" ] || fail "Action $action did not understand."

[ -x "./regress/$t.sh" ]   || fail "Test $t not found."
[ -f "./regress/$t.good" ] || fail "Expected 'good' output for test $t not found."

if [ "$action" == "run" ]
then
    sudo "./regress/$t.sh" > "regress/$t.found" 2>&1 ; diff "regress/$t.found" "regress/$t.good"
elif [ "$action" == "meld" ]
then
    meld "regress/$t.found" "regress/$t.good"
else
    fail "Action $action did not understand."
fi
