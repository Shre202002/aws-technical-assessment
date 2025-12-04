#!/bin/bash
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<html><body><h1>Hello from Vishnu Pandey</h1></body></html>" > /var/www/html/index.html