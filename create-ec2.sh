#!/bin/bash

if [ -z "$1" ]; then
  echo -e "\e[31mInput Machine Name is needed\e[0m"
  exit 1
fi

COMPONENT=$1


AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId'| sed -e 's/"//g')
SGID=$(aws ec2 describe-security-groups --filters Name=group-name,Values=allow-all-from-public | jq '.SecurityGroups[].Groupid' | sed -e 's/"//g')

echo $AMI_ID
aws ec2 run-instances \
    --image-id ${AMI_ID} \
    --instance-type t2.micro \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
    --instance-market-options "MarketType=spot",SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}" \
    --security-group-ids ${SGID} \
    | jq


