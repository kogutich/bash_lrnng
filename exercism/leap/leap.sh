#!/usr/bin/env bash

set -o errexit
set -o nounset

main() {
    if [[ "$#" -ne 1 || ! "$1" =~ ^[1-9][0-9]+$ ]]; then
        echo 'Usage: leap.sh <year>';
        exit 1;
    fi

    if (( "$1" % 4 == 0 && ("$1" % 100 != 0 || "$1" % 400 == 0) )); then
        echo "true"
    else
        echo "false"
    fi
}

main "$@"
