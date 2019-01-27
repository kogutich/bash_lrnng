#!/usr/bin/env bash

main() {
    local letters="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local letter=''

    for (( i=0; i<${#1}; i++ )); do
        letter="${1:i:1}"
        letters="${letters/${letter^^}/}"

        [[ -z "$letters" ]] && echo "true" && exit 0
    done

    echo "false"
}

main "$@"
