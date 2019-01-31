#!/usr/bin/env bash

main() {
    noPunctuation=`echo "$2" | sed 's/[^a-zA-Z0-9]//g' | tr [:upper:] [:lower:]`

    case "$1" in
        encode) transform "`echo "$noPunctuation" | sed 's/\([a-zA-Z0-9]\{5\}\)/\1 /g'`" ;;
        decode) transform "$noPunctuation" ;;
        *) exit 1 ;;
    esac
}

transform() {
    local result='' preparedStr="$1"

    for (( i=0; i < ${#preparedStr}; i++ )); do
        local ch="${preparedStr:i:1}"

        if [[ "$ch" =~ ^( |[0-9])$ ]]; then
            result+="$ch"
        else
            local code=$(( 219 - `ord ${ch}` ))
            result+=`chr ${code}`
        fi
    done

    echo ${result}
}

chr() {
  printf "\\$(printf '%03o' "$1")"
}

ord() {
  LC_CTYPE=C printf '%d' "'$1"
}

main "$@"