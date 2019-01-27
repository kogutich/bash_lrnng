#!/usr/bin/env bash

main() {
    local val=$1 result=0

    (( $val <= 0 )) && echo "Error: Only positive numbers are allowed" && exit 1

    while [[ $val -ne 1 ]]; do
        (( result += 1 ))
        (( $val % 2 == 1 )) && (( val = val * 3 + 1 )) || (( val = val / 2 ))
    done

    echo $result
}

main "$@"
