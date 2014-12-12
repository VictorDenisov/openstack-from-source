# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

KEYSTONE_IP = "172.15.0.30" # keystone ip is from management network
MYSQL_IP    = "172.15.0.31" # mysql ip is from management network

MGMT_IP = "172.15.0.7"
PUBLIC_IP = "172.30.1.8"
PRIVATE_IP = "192.168.1.8"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
	config.vm.box = "ubuntu14.04-server-amd64"
	config.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"

	config.vm.define "keystone" do |keystone|
		keystone.vm.network "private_network", ip: KEYSTONE_IP
		keystone.vm.synced_folder ".", "/vagrant", nfs: true
		keystone.vm.provision "puppet" do |puppet|
			puppet.module_path = "modules"
			puppet.manifests_path = "manifests"
			puppet.manifest_file = "keystone.pp"
			puppet.hiera_config_path = "hiera_keystone.yaml"
			puppet.facter = {
				"ip" => KEYSTONE_IP,
			}
		end
		config.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--cpus", "1"]
			vb.customize ["modifyvm", :id, "--memory", "1024"]
		end
	end

	config.vm.define "mysql-master" do |mysql_master|
		mysql_master.vm.network "private_network", ip: MYSQL_IP
		mysql_master.vm.synced_folder ".", "/vagrant", nfs: true
		mysql_master.vm.provision "puppet" do |puppet|
			puppet.module_path = "modules"
			puppet.manifests_path = "manifests"
			puppet.manifest_file = "mysql_master.pp"
			puppet.hiera_config_path = "hiera_mysql_master.yaml"
			puppet.facter = {
				"ip" => MYSQL_IP,
			}
		end
		config.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--cpus", "1"]
			vb.customize ["modifyvm", :id, "--memory", "1024"]
		end
	end

	config.vm.define "mysql-slave" do |mysql_slave|
		mysql_slave.vm.network "private_network", ip: MYSQL_IP
		mysql_slave.vm.synced_folder ".", "/vagrant", nfs: true
		mysql_slave.vm.provision "puppet" do |puppet|
			puppet.module_path = "modules"
			puppet.manifests_path = "manifests"
			puppet.manifest_file = "mysql_slave.pp"
			puppet.hiera_config_path = "hiera_mysql_slave.yaml"
			puppet.facter = {
				"ip" => MYSQL_IP,
			}
		end
		config.vm.provider :virtualbox do |vb|
			vb.customize ["modifyvm", :id, "--cpus", "1"]
			vb.customize ["modifyvm", :id, "--memory", "1024"]
		end
	end
end
