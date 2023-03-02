#!/usr/bin/env bash

#Loops based on the expression
#Loops based on the inputs, for loop command

i=5
while [ $i -gt 0 ]; do
  echo iteration - $i
  i=${($i-1)}
done