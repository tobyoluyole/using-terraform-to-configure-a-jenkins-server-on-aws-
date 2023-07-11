#!/bin/bash

sudo apt update -y

sudo apt install default-jre -y 

java -version 

sudo apt updaye -y 

wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -

sudo sh -c 'echo deb https://pkg.jenkins.io/debian binary/ > /etc/apt/sources.list.d/jenkins.list'

# Update package list and install Jenkins

sudo apt update

sudo add-apt-repository universe -y

sudo apt install jenkins

# Start Jenkins and enable it to start on boot

sudo systemctl start jenkins

sudo systemctl enable jenkins

sudo cat var/lib/jenkins/secrets/initialAdminPassword
