#!/usr/bin/env bash

set -o errexit
set -o nounset

main() {
    echo "One for ${1:-you}, one for me."
}

main "$@"
