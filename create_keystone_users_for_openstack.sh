#!/bin/bash
 
for tenant in admin demo service
do
        tenantname=`keystone tenant-list | awk "/${tenant}/ {print $4}"`
        if [ -z "${tenantname}" ];then
                keystone tenant-create --name ${tenant} --description "Openstack ${tenant} Tenant"
        else
                echo "${tenant} tenant have created"
        fi
done
 
rolename=`keystone role-list | awk -F "|" '/admin/ {print $3}'`
if [ -z "${rolename}" ];then
        keystone role-create --name admin
else
        echo "${rolename} role have created"
fi
 
for user in keystone glance nova neutron cinder swift heat admin demo
do
        name=$(keystone user-list | awk "/${user}/ {print $4}")
        password=`echo ${user} | tr '[a-z]' '[A-Z]'`_PASS
        if [ -z "${name}" ];then
                case "${name}" in
                        admin)
                                keystone user-create --name ${name} --pass ${password} --email ${name}@example.com >/dev/null
                                keystone user-role-add --user ${name} --role admin --tenant admin
                                keystone user-role-add --user ${name} --role _member_ --tenant admin
                                ;;
                        demo)
                                keystone user-create --name ${name} --pass ${password} --email ${name}@example.com >/dev/null
                                keystone user-role-add --user ${name} --role _member_ --tenant demo
                                ;;
                        *)
                                keystone user-create --name ${user} --pass ${password} --email ${user}@example.com >/dev/null
                                keystone user-role-add --user ${user} --role _member_ --tenant service
                                keystone user-role-add --user ${user} --role admin --tenant service
                                ;;
                esac
        else
                echo "$user have created"
        fi
        keystone user-role-list --user $user --tenant service
done
