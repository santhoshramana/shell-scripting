#!/bin/bash

a=100
b=devops

echo ${a}times
echo $b training
echo $date

# {} are needed if variable is combined with other words with out spaces

DATE=2022-03-10
echo Today date is $DATE

DATE=$(date +%F)
echo Today date is $DATE

x=10
y=20
ADD=$(($x+$y))
echo Add = $ADD

TIME=$(date +%T)
echo the time is $TIME

chec