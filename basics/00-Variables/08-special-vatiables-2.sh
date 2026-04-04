#!/bin/bash

echo "All arguments individually: $@"

echo " All arguments as one string: $*"

echo "Script name: $0"

echo "Current directory: $PWD"

echo "Who is running this: $User"

echo "Home directory of user: $HOME"

echo "PID of this script: $$"

sleep 50 &
echo "PID of the last command in background is: $!"

echo  "Return last executed command status :  $?"

echo "Number of arguments passed to the script: $#"

echo "#'is a special variable in Bash that represents the number of command-line arguments passed to the script : $#".

echo $-: Current shell flags/options