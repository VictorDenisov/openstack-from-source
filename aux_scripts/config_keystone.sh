#!/bin/bash

if [ $# -lt 1 ]; then
	echo "Need at least one argument"
	echo "This argument should be keystone's ip"
	exit 1
fi

ip=$1

export OS_SERVICE_TOKEN=ADMIN_TOKEN
export OS_SERVICE_ENDPOINT=http://$ip:35357/v2.0

keystone tenant-create --name=admin --description="Admin Tenant"
keystone tenant-create --name=service --description="Service Tenant"

keystone user-create --name=admin --pass=admin_pass --email=admin@example.com

keystone role-create --name=admin

keystone user-role-add --user=admin --tenant=admin --role=admin

service_id=$(keystone service-create --name=keystone --type=identity --description="Keystone Identity Service" | grep "\<id\>" | awk '{ print $4 }')

echo $service_id

keystone endpoint-create --service-id=$service_id \
	    --publicurl=http://$ip:5000/v2.0 \
	      --internalurl=http://$ip:5000/v2.0 \
	        --adminurl=http://$ip:35357/v2.0

unset OS_SERVICE_TOKEN OS_SERVICE_ENDPOINT
