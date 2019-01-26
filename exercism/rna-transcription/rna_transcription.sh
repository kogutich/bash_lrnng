#!/usr/bin/env bash

main() {
    local result=''

    for (( i=0; i<${#1}; i++ )); do
        case "${1:i:1}" in
            G) result+=C ;;
            C) result+=G ;;
            T) result+=A ;;
            A) result+=U ;;
            *) echo "Invalid nucleotide detected." && exit 1 ;;
        esac
    done

    echo "$result"
}

main "$@"