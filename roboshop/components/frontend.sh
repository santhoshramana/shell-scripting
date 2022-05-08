#!/bin/bash

source components/common.sh

Print "Installing Nginx"
yum install nginx -y &>>$LOG_FILE
StatCheck $?

Print "Downloading Nginx Content"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
StatCheck $?

Print "Cleanup old Nginx"
rm -rf /usr/share/nginx/html/* >>$LOG_FILE
StatCheck $?

cd /usr/share/nginx/html/

Print "Extract Archive"
unzip /tmp/frontend.zip &>>$LOG_FILE  && mv frontend-main/* . &>>$LOG_FILE  && mv static/* &>>$LOG_FILE .
StatCheck $?


Print "Roboshop Config file"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
for component in catalogue user cart ; do
 echo -e "Updating $component Configuration"
 sed -i -e "/${component}/s/localhost/${component}.roboshopinternal/" /etc/nginx/default.d/roboshop.conf
 StatCheck $?
done


Print "starting Nginx"
systemctl restart nginx &>>$LOG_FILE && systemctl enable nginx &>>$LOG_FILE
StatCheck $?


