#! /bin/bash

source components/common.sh


Print "Configure yum repos"
curl -f -s -L https://rpm.nodesource.com/setup_lts.x | bash - &>>${LOG_FILE}
StatCheck $?

Print "Install NodeJS"
yum install nodejs gcc-c++ -y&>>${LOG_FILE}
StatCheck $?

Print "Add Application User"
id ${APP_USER} &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  useradd ${APP_USER} &>>${LOG_FILE}
fi
StatCheck $?
Print "App content Download"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
StatCheck $?

Print "Clear old Content"
rm -rf /home/${APP_USER}/catalogue &>>${LOG_FILE}
StatCheck $?

Print "Extracting Content"
cd /home/${APP_USER} &>>${LOG_FILE} && unzip -o /tmp/catalogue.zip &>>${LOG_FILE} && mv catalogue-main catalogue &>>${LOG_FILE}
StatCheck $?

Print "Installing APP Dependencies"
cd /home/${APP_USER}/catalogue &>>${LOG_FILE} && npm install &>>${LOG_FILE}
StatCheck $?