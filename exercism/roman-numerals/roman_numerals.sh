#!/usr/bin/env bash

main() {
    declare -A mapping=(
        [1]='I' [2]='II' [3]='III' [4]='IV' [5]='V' [6]='VI' [7]='VII' [8]='VIII' [9]='IX'
        [10]='X' [20]='XX' [30]='XXX' [40]='XL' [50]='L' [60]='LX' [70]='LXX' [80]='LXXX' [90]='XC'
        [100]='C' [200]='CC' [300]='CCC' [400]='CD' [500]='D' [600]='DC' [700]='DCC' [800]='DCCC' [900]='CM'
        [1000]='M' [2000]='MM' [3000]='MMM'
    )

    local number=${1} numberLength=${#1}

    for (( i=0; i < $numberLength; i++ )); do
        local digit=${number:$i:1}

        (( $digit == 0)) && continue

        result+="${mapping[$(( $digit * (10 ** ($numberLength - $i - 1) ) ))]}"
    done

    echo "$result"
}

main "$@"
