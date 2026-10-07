#!/bin/bash

SOURCE_DIR=$1
DAYS=${3:-14}
DEST_DIR=$2
#check the source directory is provided or not
if [ -z "$SOURCE_DIR" || -z "$DEST_DIR" ]; then
    echo "Please provide both the source and destination directories"
    exit 1
fi

#check the source directory is exixts or not
if [ ! -d "$SOURCE_DIR" ]; then
    echo "The provided source directory $SOURCE_DIR does not exist"
    exit 1
fi

if [ ! -d "$DEST_DIR" ]; then
    echo "The provided destination directory $DEST_DIR does not exist"
    exit 1
fi

echo "Scanning the directory $SOURCE_DIR for log files older than $DAYS days"
FILES=$(find "$SOURCE_DIR" -type f -name "*.log" -mtime +$DAYS)

if [ -z "$FILES" ]; then
    echo "No log files found older than $DAYS days in $SOURCE_DIR"
    exit 0
fi

TIMESTAMP=$(date +%Y-%m-%d-%H-%M-%S)
ARCHIEVE_FILE="$DEST_DIR/logs-archieve-$TIMESTAMP.tar.gz"

tar -czvf $ARCHIEVE_FILE $FILES

if [ $? -eq 0 ]; then
    echo "Successfully archived the log files to $ARCHIEVE_FILE"
    while IFS= read -r FILE;
    do
        echo "Deleting the log file: $FILE"
        rm -f "$FILE"
        echo "Deleted the log file: $FILE"
    done <<< "$FILES"
else
    echo "Failed to archive the log files"
    exit 1
fi

# while IFS= read -r FILE; 
# do
#     echo "Deleting the log file: $FILE"
#     rm -f "$FILE"
#     echo "Deleted the log file: $FILE"
# done <<< "$FILES"

