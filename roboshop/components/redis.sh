#!/bin/bash

source components/common.sh


Print "Yum Repos"
url -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>${LOG_FILE}
StatCheck $?

Print "Redis Install"
yum install redis -y &>>${LOG_FILE}
StatCheck $?

Print "Updated redis config"
if [ -f /etc/redis.conf]; then
 sed -i -e 's/127/0.0.1/0.0.0.0/' /etc/redis.conf
fi
if [ -f /etc/redis/redis.conf]; then
 sed -i -e 's/127/0.0.1/0.0.0.0/' /etc/redis/redis.conf
fi
StatCheck $?

Print "Redis service starting"
systemctl enable redis &>>${LOG_FILE} && systemctl start redis &>>${LOG_FILE}
StatCheck $?
