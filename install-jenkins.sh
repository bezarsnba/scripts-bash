#!/bin/bash
# Autor: Bezaleel Ramos (bramos@onxsolutions.net)
# Nickname: Beza 
# Data: 14/07/2018
# Instalação dos pacotes Docker,git, build-essentials, java e Jenkins
# Para o 1º Hands-on DevOps Jenkins 

#Tips @spaww
paramValue() {
    echo $( echo $1 | awk -F'=' '{print $2}' );
}
function message01() {
    echo -e "\e[36m==>\e[37m $1 \e[39m";
}
function message02() {
    echo -e "\e[36m===>\e[37m $1 \e[39m";
}

# Redirect
redirectNull=$(> /dev/null 2>&1)
#Binary file
binDocker=/usr/bin/docker
binGit=/usr/bin/git
binBuild=/usr/bin/make
binJenkins=/usr/share/jenkins/jenkins.war
binJava=/usr/bin/java

## For Debug
installDocker="S"
installBuild="S"
installGit="S"
installJenkins="S"

message01 "Verificando a existencia do docker"

if [ $installDocker  == "S" ]
then
	if [ -f $binDocker ]
	then
		message02 "Binario $binDocker encontrado "
	else
		message02 "Binario não existe, inciando a instalação "  
		sudo apt-get install apt-transport-https ca-certificates curl software-properties-common -y  > /dev/null 2>&1
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -  > /dev/null 2>&1
		sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" > /dev/null 2>&1  
		sudo apt-key fingerprint 0EBFCD88 > /dev/null 2>&1
		sudo apt-get update -y > /dev/null 2>&1
		sudo apt-get install docker-ce docker-compose -y  > /dev/null 2>&1
		sudo apt-cache policy docker-ce  > /dev/null 2>&1
		message02 "Configurando usuario" > /dev/null 2>&1
		sudo groupadd docker > /dev/null 2>&1
		sudo gpasswd -a $USER docker  > /dev/null 2>&1
		message02 "Iniciando o servico" > /dev/null 2>&1
		sudo systemctl enable docker > /dev/null 2>&1
		sudo systemctl start docker > /dev/null 2>&1
	fi
fi

message01 "Verificando a existencia do git"

if [  $installGit  == "S" ]
then
	if [ -f $binGit ]
	then 
		message02 "Binario $binGit encontrado"
	else
		message02 "Binario não existe, inciando a instalação"
		sudo apt install git -y  > /dev/null 2>&1
	fi
fi

message01 "Verificando a existencia do build-essential"
    
if [  $installBuild  == "S" ]
then
	if [ -f $binBuild ]
	then 
		message02 "Binario $binBuild encontrado"
	else
		message02 "Binario não existe, inciando a instalação"
		sudo apt install build-essential -y > /dev/null 2>&1
	fi
fi

message01 "Verificando a existencia do Jenkins"

if [  $installJenkins  == "S" ]
then
	if [ -f $binJenkins ]
	then 
		message02 "Binario $binJenkins encontrado"
	else
		message02 "Binario não existe, inciando a instalação"
		wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add - > /dev/null 2>&1
		sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list' > /dev/null 2>&1
		sudo apt-get update -y > /dev/null 2>&1
		sudo apt-get install openjdk-8-jre-headless jenkins  -y > /dev/null 2>&1
		sudo systemctl enable jenkins
		sudo systemctl restart jenkins		
	fi
fi

echo "Validação:" 
echo "Docker: $($binDocker -v | head -n1)"
echo "Git: $($binGit --version | head -n1)"
echo "Build-essentials $($binBuild --version| head -n1)"
echo "Jenkins $($binJava -jar $binJenkins --version)"

message01 " Obrigado"
