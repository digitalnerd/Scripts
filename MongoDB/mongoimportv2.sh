#!/usr/bin/env bash

MONGOIMPORT=$(whereis -b mongoimport | cut -d ' ' -f2)

set -e

#read -p 'Host: ' MASTERHOST
read -p 'User: ' USER
read -sp 'Pass: ' PASS
echo
#read -p 'Port: ' PORT
#read -p 'DB: ' DB
#read -p 'Collection: ' COLLECTION
read -p 'Env: ' ENV
read -p 'File: ' FILE

LINE_NUM=$(grep "\-0" ${FILE}.json -n | cut -d ':' -f1)

for NUM in {2..9}
do

    ORIG_ENV=$(awk "NR==${LINE_NUM}" ${FILE}.json | cut -d : -f2 | tr -d ' "' | cut -d '-' -f1)
    ORIG_NUM=$(awk "NR==${LINE_NUM}" ${FILE}.json | cut -d : -f2 | tr -d ' "' | cut -d '-' -f2)
    sed -i "${LINE_NUM}s/${ORIG_ENV}/$ENV/; ${LINE_NUM}s/${ORIG_NUM}/0$NUM/" ${FILE}.json
#    sed -n ${LINE_NUM}p ${FILE}.json

    ${MONGOIMPORT} --host replica/IPADDR1:8635,IPADDR2:8635,IPADDR3:8635 --username ${USER} --password ${PASS} --authenticationDatabase admin -d raten_db_${ENV}-0${NUM} -c configContainer --file ${FILE}.json

done
