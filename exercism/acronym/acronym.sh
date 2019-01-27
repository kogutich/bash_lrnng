#!/usr/bin/env bash

main() {
    local result=''

    for word in ${*//-/ }; do
        result+="${word:0:1}"
    done

    echo "${result^^}"
}

main "$@"
