#!/usr/bin/env bash

main() {
    local prepared=$(echo "$1" | sed -e 's/-//g ') sum=0 mul=10
    [[ ! "$prepared" =~ ^[0-9]{9}([0-9]|X)$ ]] && echo "false" && exit 0

    for i in `echo "$prepared" | grep -o .`; do
        (( sum += $mul * `getNum ${i}` ))
        (( mul-- ))
    done

    (( $sum % 11 == 0 )) && echo "true" || echo "false"
}

getNum() {
    [[ "$1" = "X" ]] && echo "10" || echo "$1"
}

main "$@"
