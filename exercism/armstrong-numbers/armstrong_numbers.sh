#!/usr/bin/env bash

set -o errexit
set -o nounset

main() {
    local power=${#1}
    local result=0

    for (( i=0; i < $power; i++ )); do
        (( result += ${1:i:1} ** $power ))
    done

    (( "$result" == "$1" )) && echo "true" || echo "false"
}

main "$@"
