#!/usr/bin/env bash

source components/common.sh


print "downloading mongodb"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
Statcheck $?

print "Installing mongodb"
yum install -y mongodb-org &>>$LOG_FILE
Statcheck $?

print "update mongodb with address"
sed -i -e 's/127.0.0.1/0.0.0.0' /etc/mongod.conf
Statcheck $?

print "start mongodb"
systemctl enable mongod &>>$LOG_FILE && systemctl start mongod &>>$LOG_FILE
Statcheck $?








