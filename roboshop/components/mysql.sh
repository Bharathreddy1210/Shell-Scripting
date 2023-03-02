#!/usr/bin/env bash

source components/common.sh

print "configure yum repo"
curl -f -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
Statcheck $?

print "Install mysql"
yum install mysql-community-server -y &>>$LOG_FILE
Statcheck $?

print "Start sql service"
systemctl enable mysqld &>>LOG_FILE && systemctl start mysqld &>>$LOG_FILE
Statcheck $?

