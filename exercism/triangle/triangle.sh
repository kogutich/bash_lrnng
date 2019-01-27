#!/usr/bin/env bash

main() {
    # false when 0 exists
    for i in $2 $3 $4; do [[ "$i" = "0" ]] && echo "false" && exit 0; done

    #check triangle inequality
    ( (( `echo "$2 + $3 <= $4" | bc` )) || (( `echo "$2 + $4 <= $3" | bc` )) || (( `echo "$3 + $4 <= $2" | bc` )) ) && echo "false" && exit 0

    # uniq sides count
    local uniqCount=$(echo "$2 $3 $4" | tr ' ' '\n' | sort | uniq | wc -l)

    case "$1" in
        equilateral) (( $uniqCount == 1 )) && echo "true" && exit 0;;
        isosceles) (( $uniqCount == 2 || $uniqCount == 1 )) && echo "true" && exit 0;;
        scalene) (( $uniqCount == 3 )) && echo "true" && exit 0;;
    esac

    echo "false"
}

main "$@"
