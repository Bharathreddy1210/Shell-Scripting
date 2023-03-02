#!/usr/bin/env bash

source components/common.sh

print"configure yum repos"
curl --silent --location https://rpm.nodesource.com/setup_16.x | bash - &>>LOG_FILE
Statcheck $?

print"install Nodejs"
yum install nodejs -y &>>LOG_FILE
Statcheck $?

print"add the application user"
useradd ${APP_USER}
Statcheck $?

print"download the app component"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>LOG_FILE

print"cleanup the old content"
rm -rf /home/roboshop/catalogue &>>LOG_FILE
Statcheck $?

print"extract app content"
cd /home/roboshop &>>LOG_FILE && unzip /tmp/catalogue.zip &>>LOG_FILE && mv catalogue-main catalogue &>>LOG_FILE
Statcheck $?

print"Install app dependencies"
cd /home/roboshop/catalogue &>>LOG_FILE && npm install &>>LOG_FILE
Statcheck $?







