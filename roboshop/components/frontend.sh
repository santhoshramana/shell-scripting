#!/bin/bash

echo -e "\e[36m installing Nginx \e][0m"
yum install nginx -y

echo -e "\e[36m Downloading Nginx content \e][0m"
curl -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip"

echo -e "\e[36m Cleanup old Nginx \e][0m"
rm -rf /usr/share/nginx/html/*
cd /usr/share/nginx/html/
unzip /tmp/frontend.zip
mv frontend-main/* .
mv static/* .
rm -rf frontend-main README.md
mv localhost.conf /etc/nginx/default.d/roboshop.conf

echo -e "\e[36m starting Nginx \e][0m"
systemctl restart nginx
systemctl enable nginx