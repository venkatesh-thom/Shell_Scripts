#!/bin/bash


#export Course=Devsecops this will give in script run time
echo "Course Name Is : "$Course


#### Read -s : Read the input without showing it on the terminal. This is useful for sensitive information like passwords or PINs.
echo "Please Enter Your PIN"
read -s PIN_NUMBER # here PIN_NUMBER is variable

echo "PIN entered is: $PIN_NUMBER"