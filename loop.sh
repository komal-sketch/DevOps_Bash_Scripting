#!/bin/bash

# for loop to create multiple forlders
# in mkdir "folder$num" add $num to create folders with numbers like folder 1, folder 2 and so on..

# for (( num=1 ; num<=5; num++ ))
# do 
#     mkdir "folder$num"
# done

# to create 90 or more folders at once
<< comment
1 is argument which is folder name
2 is start range
3 is end range

run bash loop.sh day 01 90, we need to pass arg like this

comment

for (( num=$2 ; num<=$3; num++ ))
do 
  mkdir "$1$num"
done

# to remove all folders with name day: rm -r day*




