#!/bin/bash
##### File & Read and write Permission ###
check(){
    if [ -f $1 ];then
        echo "$1 file exist.."
        echo "Checking File Permissions for Read and Write"
        if [ -r $1 ] && [ -w $1 ];then
            echo "$1 File Contains both Persmissions"
        else
            echo "$1 File don't have  Persmissions"
        fi              
    else
        echo "$1 file Not exist.."
    fi     
}

read -p "Plese Enter a file name:" f
check $f 

 
