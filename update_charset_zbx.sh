#!/bin/bash

user=root
pass=zabbix
databaseName=zabbix
host=127.0.0.1

querySQL='SELECT CONCAT("ALTER TABLE ", TABLE_NAME," CONVERT TO CHARACTER SET utf8 COLLATE utf8_bin;") AS alter_sql  FROM information_schema.`COLUMNS`  WHERE table_schema = "zabbix" AND CHARACTER_SET_NAME = "latin1";'
queryValidate='SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, CHARACTER_SET_NAME, COLLATION_NAME  FROM information_schema.`COLUMNS` WHERE table_schema = "zabbix" AND COLLATION_NAME != "utf8";'


outputRes=$PWD/query_output.sql

echo $querySQL
mysql -p$pass -u$user -h$host --database $databaseName  -e "$querySQL"  > $outputRes

sed -i.bkp '/alter_sql/d' $outputRes

#cat $outputRes

mysql -p$pass -u$user -h$host --database $databaseName  -e "source $outputRes"

echo "Validando"
mysql -p$pass -uroot -h$host --database  $databaseName -e "$queryValidate"
