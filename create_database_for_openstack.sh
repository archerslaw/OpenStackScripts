#!/bin/bash
 
for db in keystone glance nova neutron cinder swift heat 
do
        mysql -e "create database $db;" 
        mysql -e "grant all privileges on ${db}.* to '${db}'@'localhost' identified by '`echo ${db} | tr '[a-z]' '[A-Z]'`_DBPASS';" 
        mysql -e "grant all privileges on ${db}.* to '${db}'@'10.1.%.%' identified by '`echo ${db} | tr '[a-z]' '[A-Z]'`_DBPASS';" 
done
