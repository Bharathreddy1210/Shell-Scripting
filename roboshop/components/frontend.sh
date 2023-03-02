#!/usr/bin/env bash

source components/common.sh


print " Installing nginx " &>>$LOG_FILE
yum install nginx -y
Statcheck $?

print " Downloading nginx "
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" &>>$LOG_FILE
Statcheck $?

print " Cleaning up the old nginx content "
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
Statcheck $?

# shellcheck disable=SC2164
cd /usr/share/nginx/html/

print " download and extract the new content "
unzip /tmp/frontend.zip >>$LOG_FILE && mv frontend-main/* . &>>$LOG_FILE && mv static/* . &>>$LOG_FILE
Statcheck $?

print " update the system configuration "
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
sed -i -e '/catalogue/s/localhost/catalogue.roboshop.internal/' /etc/nginx/default.d/roboshop.conf
Statcheck $?

print " Starting nginx "
systemctl restart nginx && systemctl enable nginx &>>$LOG_FILE
Statcheck $?

