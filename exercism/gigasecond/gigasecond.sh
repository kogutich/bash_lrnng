#!/usr/bin/env bash

echo $(env LANG=en_US date -u -d "$1 + 1000000000 seconds")