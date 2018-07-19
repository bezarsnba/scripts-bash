#!/bin/bash

#Variaveis Zabbix
dbUserZbx=zabbix
dbZbxPass=zabbix
dbSchemaZbx=zabbix
zbxWebFile="/etc/zabbix/web/"
zbxDbSource="/usr/share/doc/zabbix-server-mysql-3.4.11/create.sql.gz"
zbxConfFile="/etc/zabbix/zabbix_server.conf"

#Variaveis para Mariadb
dbRootPass=zabbix
dbUserRoot=root

#Variaveis para Php
phpLibDir="/var/lib/php/zabbix-php-fpm/"
phpConfDir="/etc/php-fpm.d/"
nginxFileConfd="/etc/nginx/conf.d"

#Adicionando Repositórios:
sudo rpm -ivh https://repo.zabbix.com/zabbix/3.4/rhel/7/x86_64/zabbix-release-3.4-2.el7.noarch.rpm
sudo yum-config-manager --enable rhel-7-server-optional-rpms

# Instalação do Server/Front/Agent
sudo yum install zabbix-server-mysql  zabbix-web-mysql zabbix-agent -y

#------------- MariaDB -------------#
#criando repositorio MariaDB.repo
sudo cat >  /etc/yum.repos.d/MariaDB.repo <<EOF
[mariadb]
name = MariaDB
baseurl = http://yum.mariadb.org/10.3/centos7-amd64
gpgkey=https://yum.mariadb.org/RPM-GPG-KEY-MariaDB
gpgcheck=1
EOF

#instalando MariaDB
sudo yum update -y
sudo yum install MariaDB-server MariaDB-client -y

#Iniciando e habilitando o serviço
sudo systemctl enable mariadb
sudo systemctl start mariadb

#Removendo usuário anonymous
#'/usr/bin/mysqladmin' -u root password 'new-password'

sudo mysql -u root <<-EOF
UPDATE mysql.user SET Password=PASSWORD('$dbRootPass') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';
FLUSH PRIVILEGES;
EOF

#Criando database para zabbix
sudo mysql -u"${dbUserRoot}" -p"${dbRootPass}" <<MY_QUERY
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by '${dbZbxPass}';
MY_QUERY

#Exportando o backup

sudo zcat $zbxDbSource | mysql -u$dbUserRoot -p$dbRootPass $dbSchemaZbx

#------------- Nginx -------------#

#Install epel-releases
sudo yum install epel-release -y
sudo yum install nginx php-fpm php-common -y

#Criando arquivo $nginxFileConfd/zabbix.conf
sudo tee -a $nginxFileConfd/zabbix.conf > /dev/null <<'EOF'
server {
    server_name ~$;
    access_log  /var/log/nginx/access_zabbix.log main;
    error_log /var/log/nginx/error_zabbix.log error;
    root /usr/share/zabbix;

   location /zabbix {
        alias /usr/share/zabbix/;
        index   index.php;

   location ~ /(conf|app|include|local)/ {
        deny all;
   }

   location ~ \.php$ {
        try_files $uri =404;
        fastcgi_pass unix:/var/run/php-zabbix.socket;
        fastcgi_index index.php;
        fastcgi_param SCRIPT_FILENAME $request_filename;
        include fastcgi_params;
        fastcgi_buffers 8 16k;
        fastcgi_buffer_size 32k;
   ## Para o  Zabbix
        fastcgi_param PHP_VALUE "
        max_execution_time = 300
                memory_limit = 128M
                post_max_size = 16M
                upload_max_filesize = 2M
                max_input_time = 300
                date.timezone = America/Sao_Paulo
                always_populate_raw_post_data = -1
        ";

   }
   }
}
EOF

#Criando o arquivo no $phpLibDir/zabbix.conf
sudo tee -a $phpConfDir/zabbix.conf > /dev/null <<'EOF'
[zabbix]
listen = /var/run/php-zabbix.socket
listen.owner = nginx
listen.group = nginx
listen.mode = 0666
user = nginx
group = nginx
pm = dynamic
pm.max_children = 50
pm.start_servers = 5
pm.min_spare_servers = 5
pm.max_spare_servers = 35
slowlog = /var/log/php-fpm/zabbix-slow.log
catch_workers_output = yes
security.limit_extensions = .php .php3 .php4 .php5
php_admin_value[error_log] = /var/log/php-fpm/zabbix-error.log
php_admin_flag[log_errors] = on
php_value[session.save_handler] = files
php_value[session.save_path] = /var/lib/php/zabbix-php-fpm/
EOF

#PHP-FPM
sudo mkdir $phpLibDir
sudo chmod 770 $phpLibDir
sudo chown root:nginx $phpLibDir
sudo chown nginx:nginx $zbxWebFile

#iniciando e habilitando
sudo systemctl enable nginx
sudo systemctl enable php-fpm  

#------------ Zabbix Front -------#

sudo systemctl restart php-fpm
sudo systemctl restart nginx

#------------- Selinux ------------#

sudo echo 0 > /sys/fs/selinux/enforce
sudo sed -i.bkp 's/SELINUX=enforcing/SELINUX=disabled/g' /etc/selinux/config 

#------------- Zabbix -------------#
sudo sed -i.bkp 's/# DBPassword=/DBPassword=zabbix/g' $zbxConfFile 
sudo systemctl enable zabbix-server
sudo systemctl start zabbix-server
