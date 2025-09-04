#!/bin/bash

# Deploy Django App with error handling

code_clone() {

echo " Clonning of Django app"
git clone https://github.com/LondheShubham153/django-notes-app.git
}

install_requirements() {
    echo "installing requirements"
    sudo apt-get install docker.io nginx -y
}

required_restarts() {
    sudo chown $USER /var/run/docker.sock
    sudo systemctl enable docker
    sudo systemctl enable nginx
    sudo systemctl restart docker
}

deploy() {
    docker build -t notes-app .
    docker run -d -p 8000:8000 notes-app:latest
}
 
if ! code_clone; then
   echo "the directory exists"
   cd django-notes-app
fi
if ! install_requirements; then
   echo " failed installation"
   exit 1
fi
if ! required_restarts; then
   echo "fault in the system"
   exit 1
if ! deploy; then
  echo "Deployment Filed, mail the admin"
  # sendmail

echo "Deplyment Done"

# Open the 8000 port on AWS linux instance, copy public ip and open the app on web
#public_ip:8000

#in this way app will be deployed with error handled


