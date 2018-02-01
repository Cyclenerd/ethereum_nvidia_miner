#!/usr/bin/env bash

#
# miner.sh
# Author: Nils Knieling - https://github.com/Cyclenerd/ethereum_nvidia_miner
#
# Start etherminer and set power limit
#

# Load global settings settings.conf
if ! source ~/settings.conf; then
	echo "FAILURE: Can not load global settings 'settings.conf'"
	exit 9
fi

# Set power limit
sudo nvidia-smi -pm ENABLED
sudo nvidia-smi -pl "$MY_WATT"
echo

export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100

#
# Ethereum Mining
#

# ethminer
# https://github.com/ethereum-mining/ethminer
# Use -G (opencl) or -U (cuda) flag to select GPU platform.
~/ethereum-mining/ethminer/build/ethminer/ethminer --farm-recheck 200 -U -S "eu1.ethermine.org:4444" -FS "us1.ethermine.org:4444" -O "$MY_ADDRESS.$MY_RIG"

# Claymore's Dual Ethereum+Decred AMD+NVIDIA GPU Miner
# https://github.com/nanopool/Claymore-Dual-Miner
#~/claymore-dual-miner/ethdcrminer64 -epool "eu1.ethermine.org:4444" -ewal "$MY_ADDRESS.$MY_RIG" -epsw x -mode 1 -ftime 10 -mport 0


#
# Monero Mining
#

# XMR-Stak - Monero/Aeon All-in-One Mining Software
# https://github.com/fireice-uk/xmr-stak
#cd ~/monero-mining
# CUDA (GPU) only mining. Disable the CPU miner backend.
#~/monero-mining/xmr-stak/build/bin/xmr-stak --noCPU
# CPU only mining. Disable the NVIDIA miner backend.
#~/monero-mining/xmr-stak/build/bin/xmr-stak --noNVIDIA


#
# Zcash Mining
#

# EWBF's CUDA Zcash Miner
# https://bitcointalk.org/index.php?topic=1707546.0
#cd ~/zcash-mining
#~/zcash-mining/ewbf/miner --fee 0 --server eu1-zcash.flypool.org:3333 --user YOUR-ZCASH-T-ADDRESS --pass x --port 3333