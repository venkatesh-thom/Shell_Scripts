#!/bin/bash 

USERID=$(id -u)

if [ $USERID -ne 0 ];then
   echo "Please run the script with root Previlages"
   exit 1
fi 

VALIDATE(){
    if [ $1 -ne 0 ];then
        echo "Error :: Installing $2 is failure"
        exit 1
    else
        echo "Installing $2 is SUCCESS"
    fi
}

dnf install mysql -y
VALIDATE  $? "MYSQL"

dnf install nginx -y
VALIDATE $? "Nginx"

dnf install python3 -y
VALIDATE $? "python3"