#!/bin/bash

# code without error handling

# create_directory() {
#     mkdir folder
# }
# create_directory
# echo "This code should work one time only"

#code with error handling

create_directory() {
    mkdir folder
}

if ! create_directory; then
    echo "The code will exit as directory already exists"
    exit 1
fi
echo "This code should work one time only"

<< comment
Without error handling → script continues even if something fails.

With error handling → script checks for errors and exits gracefully instead of continuing blindly.
comment