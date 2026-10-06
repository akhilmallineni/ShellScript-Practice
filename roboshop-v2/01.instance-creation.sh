#!/bin/bash

AMI_ID="ami-0220d79f3f480ecf5"
ZONE_ID="Z1004002PSP33W9WXUA4"
DOMAIN_NAME="akhilkumarshop.online"

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

#validation
if [ $# -lt 2 ]; then
    echo -e "$R Missing the required parameters $N and please enter Paramaeters in the below format"
    echo "$0 <Create> [instance][instance2]....]"
    exit 1
fi

ACTION=$1
shift

if [ "$ACTION" != "create" ] && [ "$ACTION" != "delete" ]; then
    echo -e "$R Invalid Action $N"
    echo "Please enter the action in the below format"
    echo "$0 <create|delete> [instance][instance2]....]"
    exit 1
fi

get_instance_id(){
    name=$1
    aws ec2 describe-instances --filters "Name=tag:Name,Values=roboshop-$name" "Name=instance-state-name,Values=running" --query "Reservations[0].Instances[0].InstanceId" --output text
}

for instance in $@
    do
        INSTANCE_ID=$(get_instance_id $instance)
        if [ "ACTION" == "create"]; then
            if [ "$INSTANCE_ID" == "None" ]; then
                echo -e "$TIMESTAMP [INFO] Creating instance for $instance"
                INSTANCE_ID=$( aws ec2 run-instances \
                --image-id $AMI_ID \
                --instance-type t3.micro \
                --security-groups "roboshop-common" "roboshop-$instance" \
                --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=roboshop-$instance}]" \
                --query 'Instances[0].InstanceId' \
                --output text 
                )
                echo "Launched Instance: $INSTANCE_ID"
                aws ec2 wait instance-running --instance-ids $INSTANCE_ID
                echo "Instance is running: $INSTANCE_ID"
            else
                echo "roboshop-$instance already running: $INSTANCE_ID"
            fi
            #Update Route 53 record
            if [ "$instance" == "frontend"]; then
                echo -e "$TIMESTAMP [INFO] Updating Route 53 record for $instance"
                IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PublicIpAddress" --output text)
                R53_RECORD="$DOMAIN_NAME"

            else
                IP=$(aws ec2 describe-instances --instance-ids $INSTANCE_ID --query "Reservations[0].Instances[0].PrivateIpAddress" --output text)
                R53_RECORD="$instance.$DOMAIN_NAME"
            fi
                aws route53 change-resource-record-sets \
                --hosted-zone-id $ZONE_ID \
                --change-batch '
                    {
                        "Comment": "Update A record to new IP",
                        "Changes": [
                            {
                                "Action": "UPSERT",
                                "ResourceRecordSet": {
                                    "Name": "'$R53_RECORD'",
                                    "Type": "A",
                                    "TTL": 1,
                                    "ResourceRecords": [
                                        {
                                            "Value": "'$IP'"
                                        }
                                    ]
                                }
                            }
                        ]
                    }
                '
            echo "updated R53 record for: $instance"
        else
            if [ $INSTANCE_ID == "None" ]; then
                echo "$instance already destroyed, nothing to do..."
            else
                aws ec2 terminate-instances --instance-ids $INSTANCE_ID
                echo "Terminating Instance: $instance"
            fi
        fi


    done
