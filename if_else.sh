#!/bin/bash

<< comment
can put multiline comments here
comment

read -p "Enter your age: " Age
if [[ $Age == 18 ]];
then
   echo "You can drive"
else
   echo "You can not drive"

fi

#Multiple conditions

read -p "Enter your City: " City
if [[ $City == Calgory ]];
then
   echo "You are eligible to apply"
elif [[ $City == toronto ]];
then 
   echo "You are still good to go"
else 
   echo "Your request is denied"

fi
