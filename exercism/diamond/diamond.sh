#!/usr/bin/env bash

main() {
    local all="ABCDEFGHIJKLMNOPQRSTUVWXYZ"
    local letter="$1" letterIndex=`getIndexByLetter "$1" "$all"`
    local lineTemplate="`printf ' %.0s' $(seq 1 $(( $letterIndex * 2 + 1 )) )`"

    for (( i=0; i < ${letterIndex}; i++ )); do
        echo "`insertLetter ${all:$i:1} "$lineTemplate" $(( $letterIndex - $i ))`"
    done

    for (( i=${letterIndex}; i >= 0; i-- )); do
        echo "`insertLetter ${all:$i:1} "$lineTemplate" $(( $letterIndex - $i ))`"
    done
}

getIndexByLetter() {
    for (( i=0; i < ${#2}; i++ )); do [[ "${2:i:1}" = "$1" ]] && echo "$i" && exit 0; done
}

insertLetter() {
    local letter="$1" template="$2" pos=$(( "$3" + 1 ))
    local secondPos="$(( ${#template} - ${pos} + 1 ))"

    echo "`echo "$template" | sed -e "s/./${letter}/${pos}" -e "s/./${letter}/${secondPos}"`"
}

main "$@"
