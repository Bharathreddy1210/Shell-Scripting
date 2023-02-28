#!/usr/bin/env bash

Statcheck() {
  if [ "$?" -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
    exit 2
  fi
  }

print() {
  echo -e "\e[36m $1 \e[0m"
}
USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo "run as a root user"
  exit 1
fi

statcheck $?

print " Installing nginx "
yum install nginx -y

statcheck $?

print " Downloading nginx "
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

statcheck $?

print " Cleaning up the old nginx content "
rm -rf /usr/share/nginx/html/*
statcheck $?

# shellcheck disable=SC2164
cd /usr/share/nginx/html/

print " download the new content "
unzip /tmp/frontend.zip && mv frontend-main/* . && mv static/* .

statcheck $?

print " update the system content "
mv localhost.conf /etc/nginx/default.d/roboshop.conf
statcheck $?

print " Starting nginx "
systemctl restart nginx && syetemctl enable nginx
statcheck $?
