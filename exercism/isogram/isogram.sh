#!/usr/bin/env bash

main() {
  local preparedStr=`echo "${1,,}" | grep -o . | sort | tr -d '\n' | tr -s '[a-z]'`
  [[ ${#1} -eq ${#preparedStr} ]] && echo "true" || echo "false"
}

main "$@"
