#!/usr/bin/env bash

main() {
    #preparing words
    words=`echo "$1" | sed -e "s/[\]n//g" -e "s/[^a-zA-Z0-9']/ /g" -e "s/\(^'\|[' ]\($\|'\| \)\+\)/ /g" | tr '[:upper:]' '[:lower:]'`

    declare -A result

    #count
    for w in $words; do (( result['$w'] = ${result[$w]:-0} + 1 )); done

    #print result
    for n in ${!result[@]}; do echo "$n: ${result[$n]}"; done
}

main "$@"