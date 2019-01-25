#!/usr/bin/env bash

set -o errexit
set -o nounset

main() {
    local result=''

    for word in ${*//-/ }; do
        result+="${word:0:1}"
    done

    echo "${result^^}"
}

main "$@"
