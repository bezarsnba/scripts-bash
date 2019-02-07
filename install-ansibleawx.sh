#!/bin/bash
## Author: Bezaleel Silva(bezarsnba)
## E-mail: bramos@onxsolutions.net
## Date: 06/02/2019
## Reference: https://github.com/ansible/awx/blob/devel/INSTALL.md#docker-or-docker-compose
## Reference: http://blog.onxsolutions.net/como-instalar-o-ansible-awx-no-ubuntu-bionic/
## Objective: shellscript to install ansible Awx, with dependence docker,npn,gnu make,git
## On Ubuntu Bionic (18.04) x86_64

## Generic functions
paramValue() {
    echo $( message $1 | awk -F'=' '{print $2}' );
}

function infoOk() {
    echo -e "\e[36m==>\e[32m $1 \e[39m";
}

function infoError() {
    echo -e "\e[31m==>\e[91m $1 \e[39m";
}

function message() {
    echo -e "\e[36m==>\e[37m $1 \e[39m";
}

## variables ###
dirSrcAwx=/opt/ansible-awx
fileDockerCompose=/var/lib/awx/docker-compose.yml
binGit=/usr/bin/git
binGcc=/usr/bin/gcc
binAnsible=/usr/bin/ansible
binDocker=/usr/bin/docker
binNpm=/usr/local/bin/npm

## verify  git
if [ -f $binGit ] 
then
   infoOk "Git Installed: $(sudo git --version | head -n1)";
  
else
   message "Git not Installed, Installing git...";
   sudo apt -y install git 
   message "Finished installation of Git: $(sudo git --version | head -n1)";
fi

## verify  gcc
if [ -f $binGcc ] 
then
   infoOk "Gcc Installed: $(sudo gcc --version | head -n1) " ;  
else
   infoError "GNU Make not Installed, Installing GNU Make...";
   sudo apt install build-essential -y &>/dev/null
   message "Finished installation of GNU Make: $(sudo gcc --version | head -n1)";
fi

## Install Ansible
if [ -f $binAnsible ] 
then
   infoOk "Ansible Installed: $( sudo ansible --version | head -n1) ";
else
   infoError "Ansible not Installed, Installing Ansible...";
   sudo apt-get install software-properties-common -y  &>/dev/null
   sudo apt-add-repository --yes --update ppa:ansible/ansible &>/dev/null
   sudo apt update &>/dev/null
   sudo apt install ansible -y &>/dev/null   
   infoOk "Finished installation Ansible:$( sudo ansible --version | head -n1)";
fi

## Install docker
if [ -f $binDocker ] 
then
   infoOk "Docker Installed: $(sudo docker --version | head -n1) ";

else
   infoError "Docker not Installed, Installing Docker";
   sudo apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y &>/dev/null
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add - &>/dev/null
   sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" &>/dev/null
   sudo apt update &>/dev/null
   sudo apt install docker-ce docker-ce-cli containerd.io docker-compose -y &>/dev/null
   sudo apt install python-pip -y &>/dev/null
   sudo pip install docker &>/dev/null
   infoOk "Finished installation of Docker: $(sudo docker --version | head -n1) ";
fi

## Install node NPM
if [ -f $binNpm ] 
then
   infoOk "NPN installed: $(sudo npm  --version | head -n1) ";
   
else
   infoError "Npm not installed, Installing NpM";
   sudo apt install nodejs npm -y  &>/dev/null
   sudo npm install npm --global &>/dev/null
   infoOk "Finished installation of NpM: $(sudo npm  --version | head -n1)";
fi
## get awx git
message "Created $dirSrcAwx and Executing git clone ";
sudo mkdir $dirSrcAwx;cd $dirSrcAwx  &>/dev/null
#sudo cp -r /vagrant/awx /opt/ansible-awx/  
sudo git clone https://github.com/ansible/awx.git &>/dev/null
infoOk "Finished execute git clone"

## run ansible-plabook
message "Running ansible-playbook...";
cd $dirSrcAwx/awx/installer
sudo ansible-playbook -e  use_docker_compose=true  -i  inventory install.yml &>/dev/null
infoOk "Finished ansible-playbook";

#check Dockercompose
if [ -f $fileDockerCompose ]
then 
   infoOk "Docker-compose exists";

else 
   message "Docker-compose not exists";
fi

message "Containers created"
sudo docker container ps
