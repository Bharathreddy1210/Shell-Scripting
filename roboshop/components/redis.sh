#!/usr/bin/env bash

source components/common.sh

print "Setup yum repos"
curl -L https://raw.githubusercontent.com/roboshop-devops-project/redis/main/redis.repo -o /etc/yum.repos.d/redis.repo &>>$LOG_FILE
Statcheck $?

print "Install Redis"
yum install redis-6.2.9 -y &>>$LOG_FILE
Statcheck $?

print "Update the redis config"
if [ -f /etc/redis.conf ]; then
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/redis.conf
fi
if [ -f etc/redis/redis.conf ]; then
  sed -i -e 's/127.0.0.1/0.0.0.0/' etc/redis/redis.conf
fi
Statcheck $?

print "Start redis service"
sysetmctl enable redis &>>$LOG_FILE && systemctl start redis &>>LOG_FILE
Statcheck $?
