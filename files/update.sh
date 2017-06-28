#!/usr/bin/env bash

# Update files from https://github.com/Cyclenerd/ethereum_nvidia_miner

echo
echo "======================================================================"
echo "Cyclenerd/ethereum_nvidia_miner ISO image UPDATE SCRIPT"
echo 
echo "Settings are now reset."
echo "======================================================================"
echo

cd ~prospector || exit 9

echo "Remove '.ssh/authorized_keys'"
rm ~/.ssh/authorized_keys
rm ~/.tmux.conf

echo; echo "Update '.bashrc'"
curl -f https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/bashrc -o .bashrc
echo; echo "Update '.screenrc'"
curl -f https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/screenrc -o .screenrc

echo; echo "Update 'miner.sh'"
curl -f https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/miner.sh -o miner.sh
echo; echo "Update 'nvidia-config.sh'"
curl -f https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/nvidia-config.sh -o nvidia-config.sh
echo; echo "Update 'nvidia-overclock.sh'"
curl -f https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/nvidia-overclock.sh -o nvidia-overclock.sh

echo; echo "Update 'myip.sh'"
curl -f https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/myip.sh -o myip.sh

echo; echo "Get 'build_ethereum-mining-etherminer.sh'"
curl -f https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/build_ethereum-mining-etherminer.sh -o build_ethereum-mining-etherminer.sh
bash build_ethereum-mining-etherminer.sh

echo
echo "======================================================================"
echo "DONE: Update"
echo "======================================================================"
echo
