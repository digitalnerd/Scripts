#!/usr/bin/env bash

# Import usages to Mongodb

MONGOIMPORT=$(whereis -b mongoimport | cut -d ' ' -f2)

set -e

read -p 'Host: ' HOST
read -p 'User: ' USER
read -sp 'Password: ' PASS
echo
read -p 'DB: ' DB
read -p 'Collection: ' COLLECTION
read -p 'File: ' FILE

for i in {1..9}
do
	  $MONGOIMPORT --host $HOST --port 8635 --username $USER --password $PASS --authenticationDatabase admin -d ${DB}_db_test-0${i} -c ${COLLECTION} --file ${FILE}.json
  done
