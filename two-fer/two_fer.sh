#!/usr/bin/env bash

set -o errexit
set -o nounset

main() {
    if [[ $# -eq 1 ]]; then
        echo "One for $1, one for me."
    else
        echo "One for you, one for me."
    fi
}

main "$@"
