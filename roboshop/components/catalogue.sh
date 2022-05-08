#! /bin/bash

source components/common.sh
Print "Configure yum repos"
curl -f -s -L https://rpm.nodesource.com/setup_lts.x | bash - &>>${LOG_FILE}
StatCheck $?

Print "Install NodeJS"
yum install nodejs gcc-c++ -y &>>${LOG_FILE}
StatCheck $?

id ${APP_USER} &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  Print "Add Application User"
  useradd ${APP_USER} &>>${LOG_FILE}
  StatCheck $?
fi

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

Print "App User Permission"
chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}
StatCheck $?

Print "SystemD File"
sed -i -e 's/MONGO_DNSNAME/mongodb.roboshopinternal/' /home/roboshop/catalogue/systemd.service &>>${LOG_FILE} && mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service &>>${LOG_FILE}
StatCheck $?

Print "Catalog Service"
systemctl daemon-reload &>>${LOG_FILE} && systemctl restart catalogue &>>${LOG_FILE} && systemctl enable catalogue &>>${LOG_FILE}
StatCheck $?