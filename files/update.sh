#!/usr/bin/env bash

#
# update.sh
# Author: Nils Knieling - https://github.com/Cyclenerd/ethereum_nvidia_miner
#
# Update files from https://github.com/Cyclenerd/ethereum_nvidia_miner
#

cd ~prospector || exit 9

echo; echo "Update '.bashrc' and '.bash_aliases'"
curl -f "https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/bashrc" -o .bashrc
curl -f "https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/bash_aliases" -o .bash_aliases
echo; echo "Update '.screenrc'"
curl -f "https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/screenrc" -o .screenrc

echo; echo "Update 'setup.sh'"
curl -f "https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/setup.sh" -o setup.sh
echo; echo "Update 'miner.sh'"
curl -f "https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/miner.sh" -o miner.sh
echo; echo "Update 'nvidia-overclock.sh'"
curl -f "https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/nvidia-overclock.sh" -o nvidia-overclock.sh

echo; echo "Update 'myip.sh'"
curl -f "https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/myip.sh" -o myip.sh

echo
echo "Done"
echo
