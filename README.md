# Repositorio de Scripts (Objetivo)

Este repositorio contém alguns scripts que desenvolvo para tarefas e correções


# Scripts

* ftpconn.py : Script que conecta via ftp com python
* install-ansibleawx.sh: Script que instala o Ansible AWS
* install-jenkins.sh: Script que instala o Jenkins
* installzabbixcentos.sh: Script de instalação do Zabbix 3.4
* shmsetup.sh: Script que calcula Pagesize e MemoryPage
* update_charset_zbx.sh: Script de correção da tabela Zabbix com latin1 ( 4.4)

## Observações

### Script update_charset_zbx.sh

Para executar o script é necessário preencher as variaveis abaixo:

```
user=root
pass=zabbix
databaseName=zabbix
host=127.0.0.1
```

Para executar basta rodar o seguinte comando:

```
# chmod +x update_charset_zbx.sh
# ./update_bash.sh 
Validando
+--------------+----------------------------+------------------------+--------------------+----------------+
| TABLE_SCHEMA | TABLE_NAME                 | COLUMN_NAME            | CHARACTER_SET_NAME | COLLATION_NAME |
+--------------+----------------------------+------------------------+--------------------+----------------+
| zabbix       | acknowledges               | message                | utf8               | utf8_bin       |
| zabbix       | actions                    | name                   | utf8               | utf8_bin       |
| zabbix       | actions                    | esc_period             | utf8               | utf8_bin       |
| zabbix       | actions                    | def_shortdata          | utf8               | utf8_bin       |
| zabbix       | actions                    | def_longdata           | utf8               | utf8_bin       |
| zabbix       | actions                    | r_shortdata            | utf8               | utf8_bin       |
| zabbix       | actions                    | r_longdata             | utf8               | utf8_bin       |
| zabbix       | actions                    | formula                | utf8               | utf8_bin       |
| zabbix       | actions                    | ack_shortdata          | utf8               | utf8_bin       |
| zabbix       | actions                    | ack_longdata           | utf8               | utf8_bin       |
| zabbix       | alerts                     | sendto                 | utf8               | utf8_bin       |
| zabbix       | alerts                     | subject                | utf8               | utf8_bin       |
| zabbix       | alerts                     | message                | utf8               | utf8_bin       |
| zabbix       | alerts                     | error                  | utf8               | utf8_bin       |
| zabbix       | application_discovery      | name                   | utf8               | utf8_bin       |
| zabbix       | application_prototype      | name                   | utf8               | utf8_bin       |
| zabbix       | applications               | name                   | utf8               | utf8_bin       |
| zabbix       | auditlog                   | details                | utf8               | utf8_bin       |
| zabbix       | auditlog                   | ip                     | utf8               | utf8_bin       |
| zabbix       | auditlog                   | resourcename           | utf8               | utf8_bin       |
| zabbix       | auditlog_details           | table_name             | utf8               | utf8_bin       |
| zabbix       | auditlog_details           | field_name             | utf8               | utf8_bin       |
| zabbix       | auditlog_details           | oldvalue               | utf8               | utf8_bin       |
| zabbix       | auditlog_details           | newvalue               | utf8               | utf8_bin       |
| zabbix       | autoreg_host               | host                   | utf8               | utf8_bin       |
| zabbix       | autoreg_host               | listen_ip              | utf8               | utf8_bin       |
| zabbix       | autoreg_host               | listen_dns             | utf8               | utf8_bin       |
| zabbix       | autoreg_host               | host_metadata          | utf8               | utf8_bin       |
| zabbix       | conditions                 | value                  | utf8               | utf8_bin       |
| zabbix       | conditions                 | value2                 | utf8               | utf8_bin       |
| zabbix       | config                     | refresh_unsupported    | utf8               | utf8_bin       |
| zabbix       | config                     | work_period            | utf8               | utf8_bin       |
| zabbix       | config                     | default_theme          | utf8               | utf8_bin       |
| zabbix       | config                     | ldap_host              | utf8               | utf8_bin       |
| zabbix       | config                     | ldap_base_dn           | utf8               | utf8_bin       |
| zabbix       | config                     | ldap_bind_dn           | utf8               | utf8_bin       |
| zabbix       | config                     | ldap_bind_password     | utf8               | utf8_bin       |
| zabbix       | config                     | ldap_search_attribute  | utf8               | utf8_bin       |
| zabbix       | config                     | severity_color_0       | utf8               | utf8_bin       |

```

# Autor

Link: https://support.zabbix.com/browse/ZBX-17357


