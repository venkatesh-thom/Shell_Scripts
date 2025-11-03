#!/bin/bash

echo "Please Enter a Number"
read NUMBER

if [ $(($NUMBER % 2 )) -eq 0 ];then
    echo "Given Number $NUMBER is Even"
else
    echo "Given Number $NUMBER is Odd"
fi    


#loops
for i in {1..5}
do
    echo $i 
done      
