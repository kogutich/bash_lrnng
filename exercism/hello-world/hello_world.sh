#!/usr/bin/env bash

main() {
  echo "Hello, World!"
}

# Calls the main function passing all the arguments to it via '$@'
# The argument is in quotes to prevent whitespace issues
main "$@"
