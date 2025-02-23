#!/bin/bash

ID=$(id -u)
LOG="/tmp/frontend.log"

stat () {
    if [ $1 -eq 0 ] ; then
    echo -e "\e[32m --success-- \e[0m"
else 
    echo  -e "\e31m --failure-- \e[0m"
fi       

}

if [ "$ID" -ne 0 ] ; then
    echo -e "\e[31m script is expected to be executed as root user or with sudo scriptname.sh \e[0m"
    echo -e "\t sudo bash $0"
    exit 1
fi

echo  " checking proxy file's presense"
if [ -f proxy.conf ] ; then
stat $?

else
    echo -e "\e[31m proxy.conf file is not present, ensure you provide the file \e[0m"
    exit 1
fi    

echo "Installing nginx"
dnf install nginx -y &>> $LOG
stat $?     

echo "copying proxy file"
cp proxy.conf /etc/nginx/default.d/expense.conf &>> /tmp/frontend.log

stat $?      

echo "enabling nginx"
systemctl enable nginx &>> $LOG
stat $? 

echo "performing a cleanup"
rm -rf /usr/share/nginx/html/* &>> $LOG
stat $? 

echo "downloading frontend"
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip &>> /tmp/frontend.log
stat $?  
cd /usr/share/nginx/html

echo "extracting frontend"
unzip /tmp/frontend.zip &>> $LOG
stat $? 

pwd &>> $LOG
ls -ltr &>> $LOG

echo "starting frontend"
systemctl restart nginx &>> $LOG
stat $? 

echo -e "\n\t \e[33m *frontend installation is completed* \e[0m"