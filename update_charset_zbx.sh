#!/bin/bash
# Data 13/04
# Autor: Bezaleel R Silva
# E-mail: bezarsnba@gmail.com
# Objetivo: Corrigir erro de latin1 encontrado na base do Zabbix

user=root
pass=zabbix
databaseName=zabbix
host=127.0.0.1

querySQL='SELECT CONCAT("ALTER TABLE ", TABLE_NAME," CONVERT TO CHARACTER SET utf8 COLLATE utf8_bin;") AS alter_sql  FROM information_schema.`COLUMNS`  WHERE table_schema = "zabbix" AND CHARACTER_SET_NAME = "latin1";'
queryValidate='SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, CHARACTER_SET_NAME, COLLATION_NAME  FROM information_schema.`COLUMNS` WHERE table_schema = "zabbix" AND COLLATION_NAME != "utf8";'
queryUpdateDataBase='ALTER DATABASE `zabbix` DEFAULT CHARACTER SET utf8 COLLATE utf8_bin;'

outputRes=$PWD/query_output.sql


mysql -p$pass -u$user -h$host --database $databaseName  -e "$querySQL"  > $outputRes

sed -i.bkp '/alter_sql/d' $outputRes

#cat $outputRes

#Uptade Table Chareset
mysql -p$pass -u$user -h$host --database $databaseName  -e "source $outputRes"

#Update Database Charset
mysql -p$pass -u$user -h$host --database $databaseName  -e "$queryUpdateDataBase"
echo "Validando"
mysql -p$pass -uroot -h$host --database  $databaseName -e "$queryValidate"
