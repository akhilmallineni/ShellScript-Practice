#!/bin/bash

Today_date=$(date)

echo "Today's date is: $Today_date"

Script_start_time=$(date +%s)
echo "Script started at: $Script_start_time"
sleep 5&
script_end_time=$(date +%s)
echo "Script ended at: $script_end_time"
script_duration=$(($script_end_time - $Script_start_time))

echo "Script duration: $script_duration seconds"

echo "All variables passed to script: $@"