#!/bin/bash

USERID=$(id -u)

if [ $USERID -ne 0 ];then
   echo "Please run the script with root Previlages"
   exit 1
fi 

echo "Installing Nginx"
dnf install Nginx -y

if [$? -ne 0 ];then
    echo "Error :: Installing Nginx is Failure"
    exit 1
else
    echo "Installing Nginx is SUCCESS"
fi          