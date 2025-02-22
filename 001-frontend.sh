#!/bin/bash

ID=$(id -u)

if [ "$ID" -ne 0 ] ; then
    echo -e "\e[31m script is expected to be executed as root user or with sudo scriptname.sh \e[0m"
    echo -e "\t sudo bash $0"
    exit 1
fi

echo "Installing nginx"
dnf install nginx -y &>> /tmp/frontend.log

if [ $? -eq 0 ] ; then
    echo -e "\e[32m --success-- \e[0m"
else 
    echo  -e "\e31m --failure-- \e[0m"
fi       

echo "copying proxy file"
cp proxy.conf /etc/nginx/default.d/expense.conf &>> /tmp/frontend.log

if [ $? -eq 0 ] ; then
    echo -e "\e[31m --success-- \e[0m"
else 
    echo  -e "\e31m --failure-- \e[0m"
fi      

echo "enabling nginx"
systemctl enable nginx &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then
    echo -e "\e[31m --success-- \e[0m"
else 
    echo  -e "\e31m --failure-- \e[0m"
fi  

echo "performing a cleanup"
rm -rf /usr/share/nginx/html/* &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then
    echo -e "\e[31m --success-- \e[0m"
else 
    echo  -e "\e31m --failure-- \e[0m"
fi  

echo "downloading frontend"
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then
    echo -e "\e[31m --success-- \e[0m"
else 
    echo  -e "\e31m --failure-- \e[0m"
fi  
cd /usr/share/nginx/html

echo "extracting frontend"
unzip /tmp/frontend.zip &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then
    echo -e "\e[31m --success-- \e[0m"
else 
    echo  -e "\e31m --failure-- \e[0m"
fi  
pwd &>> /tmp/frontend.log
ls -ltr &>> /tmp/frontend.log

echo "starting frontend"
systemctl restart nginx &>> /tmp/frontend.log
if [ $? -eq 0 ] ; then
    echo -e "\e[31m --success-- \e[0m"
else 
    echo  -e "\e31m --failure-- \e[0m"
fi  

echo "*frontend installation is completed*"