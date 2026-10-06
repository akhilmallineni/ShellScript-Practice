#!/bin/bash

LOGS_DIR="/var/log/shellscript"
sudo mkdir -p $LOGS_DIR
sudo chown ec2-user:ec2-user $LOGS_DIR
sudo chmod 755 $LOGS_DIR
LOGS_FILE="$LOGS_DIR/$0.log"

USERID=$(id -u)
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
        echo -e "$TIMESTAMP [ERROR] Installing $1 is ... $R FAILED $N" | tee -a $LOGS_FILE
        exit 1
    else
        echo -e "$TIMESTAMP [INFO] Installing $1 is ... $G SUCCESS $N" | tee -a $LOGS_FILE
    fi
}

dnf module disable redis -y &>> $LOGS_FILE
dnf enable redis:7 -y &>> $LOGS_FILE
dnf install redis -y &>> $LOGS_FILE

validate "Installing redis" $?

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf
VALIDATE "Allowing remote connections" $?

systemctl enable redis &>> $LOGS_FILE
systemctl start redis &>> $LOGS_FILE
VALIDATE $? "Started Redis"