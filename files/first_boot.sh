#!/usr/bin/env bash


#
# first_boot.sh
# Author: Nils Knieling - https://github.com/Cyclenerd/ethereum_nvidia_miner
#
# This script will reset a few settings. It runs after the first start.
#


if [ -f /home/prospector/first_boot ]; then
	
	echo "Delete SSH daemon keys"
	rm -v /etc/ssh/ssh_host_*
	
	echo
	echo "Create new SSH daemon keys"
	/usr/sbin/dpkg-reconfigure openssh-server
	
	echo
	echo "Restart SSH daemon"
	service ssh restart
	
	echo
	echo "Delete RRD munin files"
	rm -v /var/lib/munin/localhost/*
	
	# Send a nice welcome mail
	echo "Greetings from Cyclenerd <https://github.com/Cyclenerd/ethereum_nvidia_miner>" | mail -s "Happy Mining" prospector@localhost
	
	# Delete 'first_boot' file
	rm -v /home/prospector/first_boot
	
fi