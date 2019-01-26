#!/usr/bin/env bash

set -o errexit
set -o nounset

main() {
    local result='' word="$1"

    for candidate in $2; do
        isAnagram "${word^^}" "${candidate^^}" && result+=" ${candidate}"
    done

    echo $result
}

sortString() {
    echo "$*" | grep -o . | sort | tr -d '\n'; echo
}

isAnagram() {
    [[ "$1" != "$2" ]] && [[ "$(sortString "$1")" == "$(sortString "$2")" ]]
}

main "$@"
