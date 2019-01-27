#!/usr/bin/env bash

main() {
    local onlyNumbersWithoutCode=$(echo "$1" | sed -e 's/[^0-9]//g ' -e 's/^\(1\)\([0-9]\{10\}\)$/\2/')
    [[ "$onlyNumbersWithoutCode" =~ ^[2-9][0-9]{2}[2-9][0-9]{6}$ ]] && echo "$onlyNumbersWithoutCode" && exit 0
    echo "Invalid number.  [1]NXX-NXX-XXXX N=2-9, X=0-9" && exit 1
}

main "$@"
