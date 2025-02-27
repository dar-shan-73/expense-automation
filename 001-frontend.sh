#!/bin/bash

ID=$(id -u)
LOG="/tmp/frontend.log"

COLOR () {
    echo -e "\e[32m $* \e[0m"
}

stat () {
    if [ $1 -eq 0 ] ; then
    echo -e "\e[32m --success-- \e[0m"
else 
    echo  -e "\e31m --failure-- \e[0m"
    exit 1
fi       

}

if [ "$ID" -ne 0 ] ; then
    echo -e "\e[31m script is expected to be executed as root user or with sudo scriptname.sh \e[0m"
    echo -e "\t sudo bash $0"
    exit 1
fi

COLOR checking proxy file's presense
if [ -f proxy.conf ] ; then
stat $?

else
    echo -e "\e[31m proxy.conf file is not present, ensure you provide the file \e[0m"
    exit 1
fi    

COLOR Installing nginx

dnf install nginx -y &>> $LOG
stat $?     

COLOR copying proxy file
cp proxy.conf /etc/nginx/default.d/expense.conf &>> /tmp/frontend.log

stat $?      

COLOR enabling nginx
systemctl enable nginx &>> $LOG
stat $? 

COLOR performing a cleanup
rm -rf /usr/share/nginx/html/* &>> $LOG
stat $? 

COLOR downloading frontend
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip &>> /tmp/frontend.log
stat $?  
cd /usr/share/nginx/html

COLOR extracting frontend
unzip /tmp/frontend.zip &>> $LOG
stat $? 

pwd &>> $LOG
ls -ltr &>> $LOG

COLOR starting frontend
systemctl restart nginx &>> $LOG
stat $? 

echo -e "\n\t \e[33m *frontend installation is completed* \e[0m"