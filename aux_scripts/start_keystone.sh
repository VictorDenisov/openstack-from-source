#!/bin/bash

cd /vagrant/keystone

./bin/keystone-manage db_sync
./bin/keystone-all &
cd ../
./aux_scripts/config_keystone.sh 172.15.0.30
