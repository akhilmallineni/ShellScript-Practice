#!/bin/bash

#set -e

echo "Hello World"

hgdfkjsfs

echo "I am continuing..."

USERID=$(id -u)
LOG_DIR="/var/log/shellscript"
LOG_File="$LOG_DIR/$0.log"
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

if [ $USERID -ne 0 ]; then
    echo "Please run this script with root access"
    exit 1
fi

validate() {
    if [ $2 -ne 0 ]; then
        echo -e "Installing $1 is ... $R FAILED $N" | tee -a $LOG_File
        exit 1
    else
        echo -e "Installing $1 is ... $G SUCCESS $N" | tee -a $LOG_File
    fi
}

for package in $@
do
    dnf list installed $package &>> LOG_File
    if [ $? -ne 0 ]; then
        echo "Installing the $package"
        dnf install $package -y &>> LOG_File
        validate $package $?
    else
        echo "$package is already installed ... $YSKIPPING$N"
    fi

done

