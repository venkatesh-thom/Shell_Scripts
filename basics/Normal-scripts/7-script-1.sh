#!/bin/bash 


# $$ ===> This will give pid of file
# To check for both files will have same pid or not 
NAME="INDIA"
echo "My Country NAME :" $NAME
echo "PID SCRIPT-1:" $$

# this mode will give different pid for both files
#sh 19-script-2.sh

# this mode will give same pid for both files
source ./19-script-2.sh