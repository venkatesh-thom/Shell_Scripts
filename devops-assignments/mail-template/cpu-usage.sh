#!/bin/bash


# Get the CPU idle percentage from the 'top' command
# -b: batch mode
# -n1: run once
# awk '/Cpu/ {print $8}' extracts the 8th field (idle percentage) from the line containing "Cpu(s)"

# Get current CPU usage (user + system)
CPU_USAGE=$(top -bn1 | grep "Cpu(s)" | awk '{print $2 + $4}')

DISK_THRESHOLD=2 # in project we keep it as 75
# Calculate CPU usage (100 - idle_percentage)
# Round to integer
CPU_USAGE_INT=${CPU_USAGE%.*}
MESSAGE=""

# Example of conditional action based on CPU usage
if [ "$CPU_USAGE_INT" -ge $DISK_THRESHOLD ]; then
    MESSAGE+="Warning: High CPU usage detected! $CPU_USAGE_INT"
    echo -e "Message Body: $MESSAGE"
    sh mail.sh "tvenky359@gmail.com" "Current CPU Usage Alert" "Current CPU Usage" "$MESSAGE" "$IP_ADDRESS" "DevOps Team"
    # You could add commands here to send an email or log the event
else
    echo "CPU usage is normal."
fi

