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

#echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" >/tmp/rootpass.sql

echo 'show databases' | mysql -uroot -pRoboShop@1 &>>$LOG_FILE
if [ $? -ne 0 ]; then
  print "change default root password"
  echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" >/tmp/rootpass.sql
  DEFAULT_ROOT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
 mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASSWORD}" </tmp/rootpass.sql
 Statcheck $?
fi

echo shown plugins | mysql -uroot -pRoboShop@1 2>>$LOG_FILE | grep validate_password
if [ $? -eq 0 ]; then
  print "uninstall password validate plugin"
  echo "uninstall plugin validate_password;" >/tmp/passvalidate.sql
  mysql --connect-expired-password -uroot -pROboShop@1 </tmp/pass.validate.sql &>>$LOG_FILE
  Statcheck $?
fi

print "download schema"
curl -f -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>$LOG_FILE
Statcheck $?

print "Extract Schema"
cd /tmp && unzip -o  mysql.zip &>>$LOG_FILE
Statcheck $?

print "Load Schema"
cd mysql-main && mysql -u root -pRoboShop@1 <shipping.sql &>>$LOG_FILE
Statcheck $?
