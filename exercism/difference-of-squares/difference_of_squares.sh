#!/usr/bin/env bash

main() {
    case "$1" in
        square_of_sum) square_of_sum $2 ;;
        sum_of_squares) sum_of_squares $2 ;;
        difference) echo $(( `square_of_sum $2` - `sum_of_squares $2` )) ;;
        *) exit 1 ;;
    esac
}

square_of_sum() {
    local result=0

    for (( i=1; i <= $1; i++ )) do
        (( result += i ))
    done

    echo $(( result ** 2 ))
}

sum_of_squares() {
    local result=0

    for (( i=1; i <= $1; i++ )) do
        (( result += i ** 2))
    done

    echo "$result"
}

main "$@"
