#!/usr/bin/env bash

[[ "$1" = "total" ]] && echo $(echo "2^64 - 1" | bc) && exit 0
(( $1 <= 0 || $1 > 64)) && echo "Error: invalid input" && exit 1
echo $(echo "2^($1-1)" | bc)
