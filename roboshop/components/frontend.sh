#!/usr/bin/env bash

Statcheck() {
  if [ "$?" -eq 0 ]; then
    echo -e "\e[32m SUCCESS \e[0m"
  else
    echo -e "\e[31m FAILURE \e[0m"
    exit 2
  fi
  }


USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo "run as a root user"
  exit 1
fi

statcheck $?

echo -e "\e[36m Installing nginx \e[0m"
yum install nginx -y

statcheck $?

echo -e "\e[36m Downloading nginx \e[0m"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

statcheck $?

echo -e "\e[36m Cleaning up the old nginx content and downloading the new file \e[0m"
rm -rf /usr/share/nginx/html/*
# shellcheck disable=SC2164
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

statcheck $?

echo -e "\e[36m Starting nginx \e[0m"
systemctl restart nginx
systemctl enable nginx

statcheck $?
