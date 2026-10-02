#!/bin/bash
#1 create a log directory
#2. create a log file to store logs with script file name
#3.check if user ID is 0 (root)
#4. if not root, exit with message
#5.i will write a function to validate print the the packaged installed or failed
#6.i will write a block to install a package 
#7.i will add the condition to check if the package is already installed or not
#8.if pacakage not installed i will instsall the package and validate the installation using validate function

LOG_DIR="/var/log/shellscript"
LOG_File="$LOG_DIR/$0.log"

mkdir -p $LOG_DIR  # to check if the log directory is present or not, if not present it will create the log directory

if [ (id -u) -ne 0]; then
    echo "Please run this script with root access"
    exit 1
fi

VALIDATE () {
    if [ $2 -ne 0]; then
        echo "INstalling $1 is ... FAILDED" | tee -a $LOG_File
        exit 1
    else
        echo "Installing $1 is ... SUCESS" | tee -a $LOG_File
    fi
}

dnf list installed mysql &>> $LOG_File   #&>> is used to redirect both stdout and stderr to the log file

if [ $? -eq 0]: then
   echo "MYSQL is already installed ... SKIPPING" | tee -a $LOG_File
else
    echo "Installing MYSQL"
    dnf install mysql -y &>> $LOG_File
    VALIDATE MYSQL $?