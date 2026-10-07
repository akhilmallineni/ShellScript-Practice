#!/bin/bash

SOURCE_DIR=$1
DAYS=${2:-14}

#check the source directory is provided or not
if [ -z "$SOURCE_DIR" ]; then
    echo "Please provide the source directory to clean up the logs"
    exit 1
fi

#check the source directory is exixts or not
if [ ! -d "$SOURCE_DIR"]; then
    echo "The provided source directory $SOURCE_DIR does not exist"
    exit 1
fi

echo "Scanning the directory $SOURCE_DIR for log files older than $DAYS days"
FILES=$(find "$SOURCE_DIR" -type f -name "*.log" -mtime +$DAYS)

while IFS= read -r $FILES;
do

    echo "Deleting the log file: $FILES"
    rm -f "$FILES"
    echo "Deleted the log file: $FILES"
done <<< "$FILES"

