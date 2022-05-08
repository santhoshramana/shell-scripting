StatCheck() {
 if [ $? -eq 0 ]; then
   echo -e "\e[32mSUCCESS\e[0m"
 else
   echo -e "\e[31mFAILURE\e[0m"
   exit 2
 fi
}

Print() {
  echo -e "\n ----------------- $1 -----------------" &>>LOG_FILE
  echo -e "\e[36m $1 \e[0m"
}

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo you should be an root user
  exit 1
fi
LOG_FILE=/tmp/roboshop.log
rm -rf $LOG_FILE

APP_USER=roboshop

NODEJS() {

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
  curl -f -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/${COMPONENT}/archive/main.zip" &>>${LOG_FILE}
  StatCheck $?

  Print "Clear old Content"
  rm -rf /home/${APP_USER}/${COMPONENT} &>>${LOG_FILE}
  StatCheck $?

  Print "Extracting Content"
  cd /home/${APP_USER} &>>${LOG_FILE} && unzip -o /tmp/${COMPONENT}.zip &>>${LOG_FILE} && mv ${COMPONENT}-main ${COMPONENT} &>>${LOG_FILE}
  StatCheck $?

  Print "Installing APP Dependencies"
  cd /home/${APP_USER}/${COMPONENT} &>>${LOG_FILE} && npm install &>>${LOG_FILE}
  StatCheck $?

  Print "App User Permission"
  chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}
  StatCheck $?

  Print "SystemD File"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshopinternal/' /home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE} && mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/catalog${COMPONENT}ue.service &>>${LOG_FILE}
  StatCheck $?

  Print "Resart ${COMPONENT} Service"
  systemctl daemon-reload &>>${LOG_FILE} && systemctl restart ${COMPONENT} &>>${LOG_FILE} && systemctl enable ${COMPONENT} &>>${LOG_FILE}
  StatCheck $?

}