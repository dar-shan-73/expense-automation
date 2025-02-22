#!/bin/bash

ID=$(id -u)

if [ "$ID" -ne 0 ] ; then
    echo -e "\e[31m script is expected to be executed as root user or with sudo scriptname.sh \e[0m"
    echo -e "\t sudo bash $0"
    exit 1
fi

echo "Installing nginx"
dnf install nginx -y

echo "copying proxy file"
cp proxy.conf /etc/nginx/default.d/expense.conf

echo "enabling nginx"
systemctl enable nginx

echo "performing a cleanup"
rm -rf /usr/share/nginx/html/*

echo "downloading frontend"
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html

echo "extracting frontend"
unzip /tmp/frontend.zip
pwd
ls -ltr

echo "starting frontend"
systemctl restart nginx

echo "*frontend installation is completed*"