#!/bin/bash -e

cd /vagrant/keystone
./bin/keystone-manage db_sync
./bin/keystone-all &
sleep 15
#disown "%/vagrant/keystone/bin/keystone-all"
/vagrant/aux_scripts/config_keystone.sh 172.15.0.30
