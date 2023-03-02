#!/usr/bin/env bash

source components/common.sh

print "configure yum repos"
curl --silent --location https://rpm.nodesource.com/setup_16.x | bash - &>>${LOG_FILE}
Statcheck $?

print "install Nodejs"
yum install nodejs -y &>>LOG_FILE
Statcheck $?

print "add the application user"
id "${APP_USER} &>>{LOG_FILE}"
if [ $? -ne 0 ]; then
  useradd ${APP_USER} &>>LOG_FILE
fi
Statcheck $?


print "download the app component"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}

print "cleanup the old content"
rm -rf /home/${APP_USER}/catalogue &>>${LOG_FILE}
Statcheck $?

print "extract app content"
cd /home/${APP_USER} &>>${LOG_FILE} && unzip /tmp/catalogue.zip &>>${LOG_FILE} && mv catalogue-main catalogue &>>${LOG_FILE}
Statcheck $?

print "Install app dependencies"
cd /home/${APP_USER}/catalogue &>>LOG_FILE && npm install &>>${LOG_FILE}
Statcheck $?







