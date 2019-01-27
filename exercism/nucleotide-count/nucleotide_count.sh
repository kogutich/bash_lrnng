#!/usr/bin/env bash

main() {
    [[ $1 =~ [^ACGT] ]] && echo "Invalid nucleotide in strand" && exit 1

    declare -A result

    result[A]=0
    result[C]=0
    result[T]=0
    result[G]=0

    for n in $(echo $1 | grep -o .); do ((result[$n]++)); done
    for n in ${!result[@]}; do echo "$n: ${result[$n]}"; done
}

main "$@"
