#!/bin/bash

StatCheck() {
if [  $? -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e[0m"
  exit 2
fi
}

Print() {
  echo -e "\e[36m $1 \e[0m"
}

USER_ID=$(id -u)
if [  "$USER_ID" -ne 0 ]; then
  echo you should be an root user
  exit 1
fi
LOG_FILE=/tmp/roboshop.log
rm -rf $LOG_FILE

Print "Installing Nginx"
yum install nginx -y >>$LOG_FILE
StatCheck $?

Print "Downloading Nginx Content"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >>$LOG_FILE
StatCheck $?

Print "Cleanup old Nginx"
rm -rf /usr/share/nginx/html/* >>$LOG_FILE
StatCheck $?

cd /usr/share/nginx/html/

Print "Extract Archive"
unzip /tmp/frontend.zip >>$LOG_FILE $$ mv frontend-main/* . >>$LOG_FILE && mv static/* . >>$LOG_FILE
StatCheck $?


Print "Update the Roboshop Config"
mv localhost.conf /etc/nginx/default.d/roboshop.conf
StatusCheck $?

Print "starting Nginx"
systemctl restart nginx >>$LOG_FILE && systemctl enable nginx >>$LOG_FILE
StatusCheck $?


