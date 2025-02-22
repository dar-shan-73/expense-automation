#!/bin/bash

ID = $(id -u)

if [ "$ID" -ne 0 ] ; then
    echo -e "\e[31m script is expected to execute as root user \e[0m"
    exit 1
fi


dnf install nginx -y
cp proxy.conf /etc/nginx/default.d/expense.conf

systemctl enable nginx
rm -rf /usr/share/nginx/html/*
curl -o /tmp/frontend.zip https://expense-web-app.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip
pwd
ls -ltr
systemctl restart nginx

echo "*frontend installation is completed*"