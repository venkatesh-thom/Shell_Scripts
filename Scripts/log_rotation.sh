#!/bin/bash

# Log Rotation Script

# Purpose: Rotate logs in a directory, compress old logs, and clean up older backups.

: '
Find logs from the directory
Rename
Compress log files
Move to the backups directory
Clean up backups older than m no.of days
'

echo "Interpreter: $(ps -p $$ -o comm=)"
echo "Executing the script: $0"
echo "Passed total $# arguments, and they are: $@"

get_user_input(){
    # read -rp "Enter the backup directory path: " BACKUP_DIR
    # read -rp "Enter retention minutes (how long to keep old logs): " RETENTION_DAYS
    LOG_DIR=$1
    BACKUP_DIR=$2
    RETENTION_DAYS=$3
}

setup_directories(){
    # Check if the logs directory exists, and if it doesn't exist throw an error
    if [[ -d $LOG_DIR ]]; then
        echo "Log directory($LOG_DIR) exists"
    else
        echo "Error: Log directory($LOG_DIR) does not exist. Exiting."
        exit 1
    fi

    # Create a backup directory if it doesn’t exist.
    mkdir -p $BACKUP_DIR
}

# Rotate logs – get log files from the logs directory, append a timestamp, and move them to the backup directory.
## Iterate through each file in logs directory
rotate_logs(){
    for log_file in $LOG_DIR/*.log; do
        if [[ -f $log_file ]]; then # logs/app1.log
            base_name=$(basename $log_file) # app1.log
            timestamp=$(date +'%Y%m%d_%H%M%S') #20250408_102608
            backup_file="${base_name%.*}_${timestamp}.log" # app1_20250408_102608.log
            # Move log file to backup directory with updated name
            mv $log_file $BACKUP_DIR/$backup_file
            echo "Archived $log_file"
        else
            echo "Ignoring $log_file as it is a directory" 
        fi
    done
}


# Compress/zip logs in the backup directory.
compress_logs(){
    if ls "$BACKUP_DIR"/*.log 1> /dev/null 2>&1; then
        echo "Comressing log files in backup directory"
        gzip -q $BACKUP_DIR/*.log
        echo "Done with compressing!"
    else
        echo "No logs to compress."
    fi
}

# Clean up old logs that are older than a certain number of minute(s).
cleanup_old_backups(){
    echo "Cleaning up backups older than $RETENTION_DAYS minute(s)..."
    find $BACKUP_DIR -type f -name "*.gz" -mmin +$RETENTION_DAYS -exec rm -f {} \;
}

get_user_input $1 $2 $3
setup_directories
rotate_logs
compress_logs
cleanup_old_backups

echo "Log rotation completed successfully."
