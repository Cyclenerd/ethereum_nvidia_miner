#!/usr/bin/env bash

# Update files from https://github.com/Cyclenerd/ethereum_nvidia_miner

echo; echo ".bashrc"
curl -f https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/bashrc -o ~/.bashrc
echo; echo ".screenrc"
curl -f https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/screenrc -o ~/.screenrc

echo; echo "miner.sh"
curl -f https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/miner.sh -o ~/miner.sh
echo; echo "nvidia-config.sh"
curl -f https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/nvidia-config.sh -o ~/nvidia-config.sh
echo; echo "nvidia-overclock.sh"
curl -f https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/nvidia-overclock.sh -o ~/nvidia-overclock.sh

echo; echo "myip.sh"
curl -f https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/myip.sh -o ~/myip.sh

echo
echo "Done"
echo
