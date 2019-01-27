#!/usr/bin/env bash

main() {
    local noSpaces=$(echo "$1" | sed 's/ //g')
    ( (( ${#noSpaces} < 2 )) || [[ "$noSpaces" =~ [^0-9] ]] ) && echo "false" && exit 0

    local alternate=0 sum=0

    for (( i=${#noSpaces}-1; i>=0; i--)); do
        local digit=${noSpaces:i:1}

        if (( alternate )); then
            ((digit *= 2))
            ((digit > 9)) && ((digit -= 9))
        fi

        alternate=$(( ($alternate + 1) % 2 ))
        ((sum += $digit))
    done

    (( $sum % 10 == 0 )) && echo "true" || echo "false"
 }

main "$@"
