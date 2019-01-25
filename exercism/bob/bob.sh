#!/usr/bin/env bash

set -o errexit
set -o nounset

main() {
    local withoutSpaces=$(echo "$*" | sed 's/[\n\r \t]//g')
    [[ -z "$withoutSpaces" ]] && echo "Fine. Be that way!" && exit 0
    local onlyLettersAndQuestion=$(echo "$withoutSpaces" | sed 's/[^a-zA-Z?]//g')

    if [[ "$withoutSpaces" = *\? ]]; then #question
        [[ "${onlyLettersAndQuestion}" = "?" ]] && echo "Sure." && exit 0
        [[ "${onlyLettersAndQuestion^^}" = "$onlyLettersAndQuestion" ]] && echo "Calm down, I know what I'm doing!" && exit 0
        echo "Sure." && exit 0
    fi

    (( ${#onlyLettersAndQuestion} > 0 )) && [[ "${onlyLettersAndQuestion^^}" = "$onlyLettersAndQuestion" ]] && echo "Whoa, chill out!" && exit 0 #yell

    echo "Whatever."
}

main "$@"
