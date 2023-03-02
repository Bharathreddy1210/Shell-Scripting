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
  echo -e "...............$1............" &>>$LOG_FILE
  echo -e "\e[36m $1 \e[0m"
}

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo "run as a root user"
  exit 1
fi

LOG_FILE=/tmp/roboshop.log
rm -rf $LOG_FILE

# shellcheck disable=SC2034
APP_USER=roboshop

