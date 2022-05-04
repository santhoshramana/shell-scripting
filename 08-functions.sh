#!/bin/bash

# Variable : If we assign a name to set of data that is variable
# Function : If we assign a name to set of commands that is function

# func_name() {
# commands
# commands
# }

# func_name

## Declare a function

Print_Message() {
  echo Hi,
  echo Good Day
  echo Welcome to $(1) Training
  echo "my First argument is Function =$1"
  a=20
  echo "Value of a = $a"
  b=20
}

stat() {
  echo history r
  eturn 1
  echo tata
}

#Manin Prog
a=11
Print_Message DevOps

echo "my First arugument in Main script = $1"
echo "Value of b = $b"
STAT
echo Exit status of a function  stat = $?

# note
##Functions
##variables