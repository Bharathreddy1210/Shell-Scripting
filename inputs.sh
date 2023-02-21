#!/usr/bin/env bash

read -r -p 'Enter your name: ' name
echo "your name = $name"

## Special variables####
##$0-$n, "$*",/ "$@" "$#"

echo "$0" is script name
echo "$1" first argument
echo "$*" all arguments
echo "$#" number of arguments
