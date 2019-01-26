#!/usr/bin/env bash

set -o errexit
set -o nounset

main() {
    [[ "$#" -ne 1 || ! "$1" =~ ^[1-9][0-9]+$ ]] && echo 'Usage: leap.sh <year>' && exit 1
    (( "$1" % 4 == 0 && ("$1" % 100 != 0 || "$1" % 400 == 0) )) && echo "true" || echo "false"
}

main "$@"
