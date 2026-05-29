#!/bin/bash 


# $$ ===> This will give pid of file
# To check for both files will have same pid or not 
NAME="INDIA"
echo "My Country NAME :" $NAME
echo "PID SCRIPT-1:" $$


## How can you call other scripts in shell

## script-1 -> script-2

#### sh script-2.sh
# 1. different PID
# 2. cant access parent env
sh script-2.sh


## source script-2.sh
## 1. same PID
## 2. can access parent env

source ./8-script-2.sh