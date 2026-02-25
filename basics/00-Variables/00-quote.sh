#!/bin/bash

#######Understanding Variables in Shell Scripting######

#Declaring a variable and using it
RG='Venkatesh-SecOps'
echo $RG
echo "${RG}"

#Using variables with single and double quotes
X=10
RG='Venkatesh-SecOps-$X'  # Won't expand the variable
echo $RG  # Outputs: Venkatesh-SecOps-$X

RG="Venkatesh-SecOps-$X"  # Will expand the variable
echo $RG  # Outputs: Venkatesh-SecOps-10
