#!/bin/bash

#take input from the user

echo "Enter the username"
read Username
echo "You entered $Username"

#you can give the prompt like below as well

read -p "Enter Username: " Username
echo "You entered $Username"

#now to add a new user

sudo useradd -m $Username
echo "New User added"

#to make the file executable: chmod 755
#to check the added user on linux machine: cat /etc/passwd
