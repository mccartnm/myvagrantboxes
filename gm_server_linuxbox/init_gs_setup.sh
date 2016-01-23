#!/bin/bash

########################################
# Basic Setup and package installation #
########################################

PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
  echo ""
  exit
fi

## For Me. ST3 to edit anything I don't want to use vim for.
add-apt-repository ppa:webupd8team/sublime-text-3

# Now update whatever we can
apt-get update

# Code Modification
apt-get install -y git
apt-get install -y sublime-text-installer
apt-get install -y vim

# Python
apt-get install -y python python-pip
apt-get install -y python-dev # Not needed but nice to have.

# Virtual Environment
pip install virtualenv

# screen for multi buffer work
apt-get install -y screen

ln -s /vagrant /home/vagrant/vagrant # symlink

#### Actual Game Server Related Stuff ####

# murmur (mumble-server)
sudo apt-get install -y mumble-server

# Apache2 for web service and initial protocols...
sudo apt-get install -y apache2
cp /home/vagrant/vagrant/apache2.conf /etc/apache2
cp -r /home/vagrant/vagrant/cgi-bin /usr/lib

a2enmod cgi # to let the diagnostics run...
service apache2 restart # to get the new configuration caught up...	

## And Finally finish up!
date > "$PROVISIONED_ON"
echo "Completed setting up VM for basic Game Server. You should start by ssh-ing into the VM and running dpkg-reconfigure mumble-server."