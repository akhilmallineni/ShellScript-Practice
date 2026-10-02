#!/bin/bash

USERID=$(id -u)
LOG_DIR="/var/log/shellscript"
LOG_File="$LOG_DIR/$0.log"

if [ $USERID -ne 0 ]; then
    echo "Please run this script with root access"
    exit 1
fi

Validate () {
    if [ $2 -ne 0]; then
        echo "Installing $1 is ... FAILED" | tee -a $LOG_File
        exit 1
    else
        echo "Installing $1 is ... SUCCESS" | tee -a $LOG_File
    fi
}

for package in $@
do
    dnf list installed $package &>> $LOG_File
    if [ $? -ne 0 ]; then
        echo "installing the $package"
        dnf install $package -y &>> $LOG_File
        Validate $package $?
    else
        echo "$package is already installed ... SKIPPING" | tee -a $LOG_File
    fi
done
