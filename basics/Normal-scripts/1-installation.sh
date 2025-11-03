#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ];then
   echo "Please run the script with root Previlages"
   exit 1
fi 

dnf install mysql -y

if [$? -ne 0 ];then
    echo "Error :: Installing Mysql is Failure"
    exit 1
else
    echo "Installing MySQL is SUCCESS"
fi          