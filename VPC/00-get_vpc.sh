#!/bin/bash

#### This script retrieves VPC IDs from a specified AWS region.####


### ----> $# – Number of Arguments
### ----> Represents the number of arguments passed to the script.
echo "Checking Number of arguments"
echo "Number of arguments: $#"

# Check if at least one argument is provided
if [ $# -gt 0 ]; then
    REGIONS=$@
    echo "Fetching VPC IDs for regions: $REGIONS"
    for REGION in $REGIONS; do
        aws ec2 describe-vpcs --region ${REGION} | jq ".Vpcs[].VpcId" -r
    done
else
    echo "You have provided $# arguments. Please provide at least one region."
    exit 1
fi


##Running get_vpc.sh 
####----> /get_vpc.sh us-east-1 ap-south-1 us-east-2

# ### Output 
# vpc-0abcd1234efgh5678
# vpc-1bcde2345fghij678
# ...
