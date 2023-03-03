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

APP_SETUP() {
  id ${APP_USER} &>>$LOG_FILE
  if [ $? -ne 0 ]; then
  useradd ${APP_USER} &>>$LOG_FILE
  Statcheck $?
  fi

print "download the app component"
  curl -f -s -L -o /tmp/$COMPONENT.zip "https://github.com/roboshop-devops-project/$COMPONENT/archive/main.zip" &>>$LOG_FILE

  print "cleanup the old content"
  rm -rf /home/${APP_USER}/$COMPONENT &>>$LOG_FILE
  Statcheck $?

  print "extract app content"
  cd /home/${APP_USER} &>>$LOG_FILE && unzip /tmp/$COMPONENT.zip &>>$LOG_FILE && mv $COMPONENT-main $COMPONENT &>>$LOG_FILE
  Statcheck $?
}


SERVICE_SETUP(){

   print "App user permissions"
    chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}
    Statcheck $?

    print "Setup SystemID File"
    sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/' -e 's/CARTENDPOINT/cart.roboshop.internal/' -e 's/DBHOST/mysql.roboshop.internal/' /home/roboshop/$COMPONENT/systemd.service &>>$LOG_FILE && mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service &>>$LOG_FILE
    Statcheck $?

    print "restart ${COMPONENT} service"
    systemctl daemon-reload &>>$LOG_FILE && systemctl restart $COMPONENT &>>$LOG_FILE && systemctl enable $COMPONENT &>>$LOG_FILE
    Statcheck $?

}

NODEJS() {
  print "configure yum repos"
  curl --silent --location https://rpm.nodesource.com/setup_16.x | bash - &>>$LOG_FILE
  Statcheck $?

  print "install Nodejs"
  yum install nodejs -y &>>$LOG_FILE
  Statcheck $?

  print "add the application user"

  APP_SETUP

  print "Install app dependencies"
  cd /home/${APP_USER}/$COMPONENT &>>LOG_FILE && npm install &>>$LOG_FILE
  Statcheck $?

  print "App user permissions"
  chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}
  Statcheck $?

  print "Setup SystemID File"
  sed -i -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_ENDPOINT/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/' -e 's/CATALOGUE_ENDPOINT/catalogue.roboshop.internal/'/home/roboshop/$COMPONENT/systemd.service &>>$LOG_FILE && mv /home/roboshop/$COMPONENT/systemd.service /etc/systemd/system/$COMPONENT.service &>>$LOG_FILE
  Statcheck $?

  print "restart ${COMPONENT} service"
  systemctl daemon-reload &>>$LOG_FILE && systemctl restart $COMPONENT &>>$LOG_FILE && systemctl enable $COMPONENT &>>$LOG_FILE
  Statcheck $?

}

MAVEN() {
  print "Install Maven"
  yum install maven -y &>>$LOG_FILE
  Statcheck $?

  APP_SETUP

  print "Maven package"
  cd /home/$(APP_USER)/${COMPONENT} && mvn clean package &>>$LOG_FILE && mv target/shipping-1.0.jar shipping.jar &>>$LOG_FILE
  Statcheck $?




}

