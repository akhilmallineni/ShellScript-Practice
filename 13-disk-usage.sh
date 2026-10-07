#!/bin/bash

DISK_USAGE=$(df -hP | grep -v Filesystem)
USAGE_THRESHOLD=10
SERVER_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)

while IFS= read -r line
do
    USAGE=$( echo "$line" | awk '{print $5}' | cut -d "%" -f1 )
    PARTITION=$( echo "$line" | awk '{print $6}' )

    if [ "$USAGE" -ge "$USAGE_THRESHOLD" ]; then
        MESSAGE+="High Disk Usage on $PARTITION: $USAGE \n"
    fi
done <<< "$DISK_USAGE"

echo "$MESSAGE"