#!/bin/bash

ID=$(id -u)
LOG="/tmp/mysql.log"

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

dnf install mysql-server -y &>> $LOG
systemctl enable mysqld  &>> $LOG
systemctl start mysqld  &>> $LOG
mysql_secure_installation --set-root-pass ExpenseApp@1
echo "**mysql installation completed**"