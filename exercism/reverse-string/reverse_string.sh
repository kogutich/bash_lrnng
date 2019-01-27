#!/usr/bin/env bash

main() {
    local reversed=''

    for (( i=${#1} - 1; i >= 0; i-- ))
        do reversed+=${1:$i:1}
    done

    echo "$reversed"
}

main "$@"
