#!/bin/bash

echo "Starting user-data script..."

apt-get update -y

apt-get install nginx -y

echo "Hi Girik" > /var/www/html/index.nginx-debian.html

systemctl start nginx
systemctl enable nginx

echo "User-data script completed successfully!"
