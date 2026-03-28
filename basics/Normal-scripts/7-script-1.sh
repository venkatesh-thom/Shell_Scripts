#!/bin/bash 


# $$ ===> This will give pid of file
# To check for both files will have same pid or not 
NAME="INDIA"
echo "My Country NAME :" $NAME
echo "PID SCRIPT-1:" $$

# this mode will give different pid for both files
# Direct calling of file  call by sh <script-name> runs in different process, can't access script-1 environment. script-1 is not effected by script-2 failure
#sh 8-script-2.sh

# this mode will give same pid for both files
# Indirect calling of file with source command [ . represent current directory ] source <script-name> runs in the same proces sof script-1 can access script-1 environment. script-1 is effected by script-2 failure
source ./8-script-2.sh