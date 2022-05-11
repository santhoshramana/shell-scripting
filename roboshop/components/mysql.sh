#!/bin/bash

source components/common.sh

Print "Configure YUM repos"
curl -f -s -L -o curl -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>${LOG_FILE}
StatCheck $?

Print "Install MySQL"
yum install mysql-community-server -y &>>${LOG_FILE}
StatCheck $?

#Print "Install MySQL"
#yum install mysql-community-server -y &>>${LOG_FILE}
#StatCheck $?

Print "Start Mysql"
systemctl enable mysql &>>${LOG_FILE} && systemctl start mysql &>>${LOG_FILE}
StatCheck $?


