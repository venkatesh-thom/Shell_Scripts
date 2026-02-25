#!/bin/bash

NUMBER=$1
if [ $NUMBER -lt 10 ];then
    echo "Given Number $NUMBER is less than 10"
elif [ $NUMBER -eq 10 ];then
    echo "Given Number $NUMBER is equal to 10"
elif [ $NUMBER -gt 10 ];then
    echo "Given Number $NUMBER is greater to 10"
else 
    echo "Given Number $NUMBER Not valid"
fi 


#sh 09-condtions.sh  0.5 ==> [: 0.5: integer expression expected
# -gt
# -eq
# -ne
        