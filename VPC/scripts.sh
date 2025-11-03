#!/bin/bash

# Suppress AWS CLI version output
aws --version > /dev/null 2>&1

echo "Checking Number of arguments"
echo "Number of arguments: $#"

# Check if the previous command was successful
if [ $? -eq 0 ]; then
    REGIONS=$@
    echo "Fetching VPC IDs for regions: $REGIONS"
    for REGION in $REGIONS; do
        aws ec2 describe-vpcs --region ${REGION} | jq ".Vpcs[].VpcId" -r
    done
else 
    echo "Incorrect AWS command. Please check your AWS CLI installation."
    exit 1
fi




### Running ----> script.sh 
### ./script.sh us-east-1 us-east-2 ap-southeast-1

#### Output ####
# Fetching VPC IDs for regions: us-east-1 us-east-2 ap-southeast-1
# vpc-0abcd1234efgh5678
# vpc-1bcde2345fghij678
# ...