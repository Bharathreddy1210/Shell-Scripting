#!/usr/bin/env bash

source components/common.sh


print "downloading mongodb"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
Statcheck $?

print "Installing mongodb"
yum install -y mongodb-org &>>$LOG_FILE
Statcheck $?

print "update mongodb with address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
Statcheck $?

print "start mongodb"
systemctl enable mongod &>>$LOG_FILE && systemctl start mongod &>>$LOG_FILE
Statcheck $?

print "download schema"
curl -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip"
Statcheck $?

print "Extract Schema"
cd /tmp && unzip mongodb.zip &>>LOG_FILE
Statcheck $?

print "Load schema"
cd mongodb-main && mongo < catalogue.js &>>LOG_FILE && mongo < users.js &>>LOG_FILE
Statcheck $?







