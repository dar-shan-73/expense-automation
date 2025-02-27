#!/bin/bash

ID=$(id -u)
LOG="/tmp/mysql.log"
COMPONENT="mysql"

COLOR () {
    echo -e "\e[35m $* \e[0m"
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

COLOR installing $COMPONENT
dnf install mysql-server -y &>> $LOG
stat $?

COLOR enabling $COMPONENT
systemctl enable mysqld  &>> $LOG
stat $?

COLOR starting $COMPONENT
systemctl start mysqld  &>> $LOG
stat $?

COLOR configuring $COMPONENT root password
mysql_secure_installation --set-root-pass ExpenseApp@1
stat $?


echo -e "\n\t **mysql installation completed**"