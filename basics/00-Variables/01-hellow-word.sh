#!/bin/bash

echo "Hello world"
echo

#-n - Don't add a new line at the end
echo -n "Hello," ;  echo -n "world" 
echo

#-e Option: Enable Backslash Escapes
echo -e  "\n Hello \n world"
echo  #echo :empty echo will give a space between two lines

#-E Option: Disable Backslash Escapes
echo -E "Hello\nWorld!"



