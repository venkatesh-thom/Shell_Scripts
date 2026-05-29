#!/bin/bash

# Define the memory usage threshold (in percentage)
THRESHOLD=2 # in project we keep it as 75
MESSAGE=""


# Get current memory usage percentage
# 'free -m' shows memory in MB
# 'awk' extracts the relevant numbers for total and used memory
# 'bc' calculates the percentage with two decimal places
MEM_USAGE_PERCENT=$(free -m | awk '/Mem/{printf("%.2f\n"), $3/$2*100}')

# Extract the integer part of the memory usage percentage
INT_MEM_USAGE=$(echo $MEM_USAGE_PERCENT | cut -d'.' -f1)

# Check if memory usage exceeds the threshold
if [ "$INT_MEM_USAGE" -ge "$THRESHOLD" ]; then
    # Prepare the email subject and body
    SUBJECT="Memory Usage Alert on $(hostname) - $MEM_USAGE_PERCENT%"
    MESSAGE="Current memory usage on $(hostname) is $MEM_USAGE_PERCENT%. Please investigate."

    # Send the email
    echo -e "Message Body: $MESSAGE"
    #echo -e "$BODY" | mail -s "$SUBJECT" "$RECIPIENT_EMAIL"
    #echo "Memory usage alert sent to $RECIPIENT_EMAIL."
    sh mail.sh "tvenky359@gmail.com" "$SUBJECT" "Memory Usage Alert" "$MESSAGE" "$IP_ADDRESS" "DevOps Team"  
else
    echo "Memory usage is within the acceptable threshold ($MEM_USAGE_PERCENT%)."
fi




#!/bin/bash
free_mem=$(free -m | awk 'NR==2 {print $4}')
if [ $free_mem -lt 500 ]; then
echo "Low memory: $free_mem MB"
fi
