#!/usr/bin/python
# -*- coding: latin-1 -*-
# Autor: Bezaleel Ramos da Silva 
# Data: 22/12/2015
# Verifica arquivo FTp
# Usuário anonimos

import ftplib
from datetime import datetime
import datetime as dt
import time
from time import gmtime, strftime

ftp = ftplib.FTP('ftp.com.br')
ftp.login()
FileName="File.txt"
ftp.cwd("dirname")
resp=ftp.sendcmd("MDTM %s" % FileName)
Timestamp = datetime.strptime(resp.split(' ')[1],"%Y%m%d%H%M%S").strftime("%H:%M:00").split(':')[0]
now=dt.datetime.now()
minuteNow = time.strftime("%H:%M:00", gmtime()).split(':')[0]

if minuteNow == Timestamp :
    print "0"
else:
    print "1"
