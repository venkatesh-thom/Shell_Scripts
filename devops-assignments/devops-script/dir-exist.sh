#! /bin/bash

check(){
    if [ -d $1 ];then
        echo "$1 dir exist"
        echo "Listing the directory"
        ls -l 
    else
        echo "$1 dir Not exist"
    fi     
        
}

read -p "Please Enter a dir name :" d 
check $d