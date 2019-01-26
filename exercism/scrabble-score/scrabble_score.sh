#!/usr/bin/env bash

set -o errexit
set -o nounset

main() {
    local result=0

    for (( i=0; i < ${#1}; i++ )) do
        local ch=${1:${i}:1}

        case "${ch^^}" in
            A|E|I|O|U|L|N|R|S|T) ((result+=1)) ;;
            D|G) ((result+=2)) ;;
            B|C|M|P) ((result+=3)) ;;
            F|H|V|W|Y) ((result+=4)) ;;
            K) ((result+=5)) ;;
            J|X) ((result+=8)) ;;
            Q|Z) ((result+=10)) ;;
        esac
    done

    echo "$result"
}

main "$@"
