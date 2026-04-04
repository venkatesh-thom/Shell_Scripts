#!/bin/bash

usage=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ $usage -gt 80 ]; then
echo "Disk usage is high: $usage%"
fi


#df / → checks only /