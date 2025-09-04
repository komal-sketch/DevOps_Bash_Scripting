#!/bin/bash

#Variable = whose value can change.

name="Rehana"
echo "Name is $name"

#add $ to identify variable


name="Rehana"
echo "Name is $name and Date is $(Date)"

# date is a command, so to run it this way.
# to take the input from the user:

echo "Enter the name"
read Username

echo "You entered $Username"

#Arguments: are usefull when we need to add multiple users at once
#example: user_creation.sh komal Rehana PK, so here user_creation.sh is &0th argument komal is $1st and so on..








