#!/usr/bin/env bash

a=n
b=Devops

echo ${a}value
echo $b practice

# variables

a=100
b=200

add=$(($a+$b))

echo result is $add

Date=$(date +%F)
echo -e today date is $Date

## Scalar

B=(30 first 40 second)
echo the first value of the set = ${B[0]}
echo the second value of the set = ${B[1]}
echo to dispaly the total values = ${B[*]}
