#!/bin/bash

##Read a file line by line
filename="myfile.txt"

while IFS= read -r line; 
    do
    line=${line%$'\r'}  # Remove carriage return if present
    echo "Line: $line"
done < "$filename"