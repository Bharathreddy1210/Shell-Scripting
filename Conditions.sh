#!/usr/bin/env bash

# if conditions are avaliable in three forms
# simple if
#Demo
#if [expression]
#then
#command
#fi

#example

#if [ 25 -ne 30 ]
#then
#echo condition satisfied
#fi


# shellcheck disable=SC2034
a="xyz"

if [ '$a' == "xyz" ]; then
  echo "the equation is true"
fi

if [ '$b' != "xyz" ]; then
  echo "the equation is false"
fi

