#!/usr/bin/env bash

alphabet="abcdefghijklmnopqrstuvwxyz"

main() {
    local action="$1" a="$2" b="$3" str="$4" m=26

    [[ `gcd "$a" "$m"` -ne 1 ]] && echo "a and m must be coprime." && exit 1

    str=`echo "$str" | sed 's/[^a-zA-Z0-9]//g' | tr [:upper:] [:lower:]`

    case "$action" in
        encode|decode) $action "$str" "$a" "$b" "$m" ;;
        *) exit 1 ;;
    esac
}

gcd() {
    [[ "$2" -eq 0 ]] && echo "$1" || echo $(gcd "$2" "$(( "$1" % "$2" ))")
}

encode() {
    local result='' str="$1" a="$2" b="$3" m="$4"

    for (( i=0; i < ${#str}; i++ )); do
        local char="${str:i:1}"

        if [[ "$char" =~ [0-9] ]]; then
            result+="$char"
        else
            local x=`getIndexByLetter ${char}`
            local Ex=$(( (${a} * ${x} + ${b} ) % ${m} ))
            result+=`getLetterByIndex ${Ex}`
        fi
    done

    echo `echo "$result" | sed 's/\([a-zA-Z0-9]\{5\}\)/\1 /g'`
}

decode() {
    local result='' str="$1" a="$2" b="$3" m="$4" mmi=`getMMI ${a} ${m}`

    for (( i=0; i < ${#str}; i++ )); do
        local char="${str:i:1}"

        if [[ "$char" =~ [0-9] ]]; then
            result+="$char"
        else
            local y=`getIndexByLetter ${char}`
            local Dy=`mod $(( (${mmi} * (${y} - ${b}) ) )) ${m}`
            result+=`getLetterByIndex ${Dy}`
        fi
    done

    echo "$result"
}

mod () {
    echo $(( ($1 % $2 + $2) % $2 ))
}

getMMI() {
    local a="$1" m="$2"

    for (( x=1; x < $m; x++ )); do
        (( ($a * $x) % $m == 1 )) && echo $x && exit 0
    done
}

getIndexByLetter() {
    for (( i=0; i < ${#alphabet}; i++ )); do [[ "${alphabet:i:1}" = "$1" ]] && echo "$i" && exit 0; done
}

getLetterByIndex() {
    echo "${alphabet:$1:1}"
}

main "$@"
