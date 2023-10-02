#!/bin/bash

### Скрипт удаленного выполнения бэкапа.
### Скрипт подключается к удаленным серверам и запускает локальный скрипт бэкапа.
### Локальный скрипт бэкапа "local_backup.sh" выполняет дамп БД в sql-файл.
### Затем, sql-файл помещается в tar-бол.
### 
### После успешного завершения выполняется копирование на удаленный сервер.
### Скрипт запускается по cron.

SRC="/home/backup/scripts/local_backup.sh"
DST=""
TIME=$(date +'%d%m%Y')
LOGFILE="/var/log/remote_backup.log"

echo >> ${LOGFILE}
echo "// BEGIN -- ${TIME}"  >> ${LOGFILE}

# Удаленное выполнение скрипта бэкапа на сервере zabbix
echo "[*-----] Connect to zabbix.digitalnerd.ru and run local_backup.sh script..." >> ${LOGFILE}
/usr/bin/ssh zabbix.digitalnerd.ru "${SRC}"
if [[ $? != 0 ]]; then
    echo "[*-----] Failed! Не удалось запустить скрипт бэкапа с сервера zabbix..." >> ${LOGFILE}
    exit 1
else
    echo "[**----] Done." >> ${LOGFILE}
fi

# Копирование tar-бола БД с сервера zabbix на сервер бэкапа
echo "[***---] Copying database from zabbix to backup-server..." >> ${LOGFILE}
scp zabbix.digitalnerd.ru:/home/backup/zabbix.${TIME}.sql.gz /home/backup/BACKUP/zabbix.digitalnerd.ru/
if [[ $? != 0 ]]; then
    echo "[***---] Failed! Не удалось скопировать БД..." >> ${LOGFILE}
    exit 1
else
    echo "[****--] Done." >> ${LOGFILE}
fi

echo "[*****-] Removing zabbix.${TIME}.sql.gz from zabbix..." >> ${LOGFILE}
/usr/bin/ssh zabbix.digitalnerd.ru "rm /home/backup/zabbix.${TIME}.sql.gz"
if [[ $? != 0 ]]; then
    echo "[*****-] Failed! Не удалось удалить zabbix.${TIME}.sql.gz с zabbix..." >> ${LOGFILE}
    exit 1
else
    echo "[******] Done." >> ${LOGFILE}
fi


echo "// END -- ${TIME}"  >> ${LOGFILE}
#/bin/bash ns1.digitalnerd.ru "/home/backup/scripts/local_backup.sh"
#/bin/bash ns2.digitalnerd.ru "/home/backup/scripts/local_backup.sh"
