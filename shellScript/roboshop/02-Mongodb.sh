#!/bin/bash

LOG_DIR="/var/log/shellscript"
sudo mkdir -p $LOG_DIR
sudo chown ec2-user:ec2-user $LOG_DIR
sudo chmod 755 $LOG_DIR
LOg_File="$LOG_DIR/$0.log"

USER_ID=$(id-u)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

if [ $USER_ID -ne 0 ]; then
    echo "Please run this script with root access"
    exit 1
fi

validate() {
    if [ $2 -ne 0 ]; then
        echo -e "$TIMESTAMP [ERROR] Installing $1 is ... $R FAILED $N" | tee -a $LOG_File
        exit 1
    else
        echo -e "$TIMESTAMP [INFO] Installing $1 is ... $G SUCCESS $N" | tee -a $LOG_File
    fi
}

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOG_File
validate "MongoDB Repo" $?

dnf install mongodb-org -y &>> $LOG_File
validate "MongoDB" $?

systemctl enable mongod --new mongod &>> $LOG_File
validate "MongoDB Service" $?

systemctl start mongod &>> $LOG_File
validate "MongoDB Service Start" $?

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOG_File
validate "MongoDB Config" $?

systemctl restart mongod &>> $LOG_File
validate "MongoDB Service Restart" $?