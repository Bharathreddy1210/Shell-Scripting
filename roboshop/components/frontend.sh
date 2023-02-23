#!/usr/bin/env bash

echo -e "\e[36m Installing nginx \e[0m"
yum install nginx -y

echo -e "\e[36m Downlaoding nginx \e[0m"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

echo -e "\e[36m Cleaning up the old nginx content and downloading the new file \e[0m"
rm -rf /usr/share/nginx/html/*
# shellcheck disable=SC2164
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m Starting nginx \e[0m"
systemctl restart nginx
systemctl enable nginx
