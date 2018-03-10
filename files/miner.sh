#!/usr/bin/env bash

#
# miner.sh
# Author: Nils Knieling - https://github.com/Cyclenerd/ethereum_nvidia_miner
#
# Set power limit and start ethminer
#
# Changelog
# 2018/03/10 Andrea Lanfranchi - https://github.com/AndreaLanfranchi/ethereum_nvidia_miner
# - Implemented optional per GPU fine tuning
# - Added NO_COLOR env var for recent releases of ethminer
#

# Load global settings settings.conf
# shellcheck source=settings.conf
# shellcheck disable=SC1091
# shellcheck disable=SC2086
# shellcheck disable=SC2154

if ! source ~/settings.conf; then
	printf "FAILURE: Can not load global settings 'settings.conf'\n\n"
	exit 9
fi

# Set power limit
sudo nvidia-smi -pm ENABLED

# Check if Power Limit is global or per GPU
unset MY_WATT_X
if set -o posix; set | grep -q -E "^MY\_WATT\_[0-9]{1,2}" ; then MY_WATT_X="1"; fi;
if [ -z ${MY_WATT_X+x} ]; 
then
	MY_VAR="MY_WATT"
	unset MY_VAL
	if [ ! -z ${!MY_VAR} ] ; then MY_VAL=${!MY_VAR}; fi;
	if [ ! -z ${MY_VAL+x} ] ; 
	then
        printf "\nApplying Power Limit for ALL GPUs \n--------------------------------------------------------------------------------\n" 
	    sudo nvidia-smi -pl "$MY_VAL"
	fi;
else

	nvidia-smi --format=csv,noheader --query-gpu=index | while read -r MY_DEVICE; do
	
	    MY_VAR="MY_WATT_$MY_DEVICE"
	    unset MY_VAL
	    if [ ! -z ${!MY_VAR} ] ; then MY_VAL=${!MY_VAR}; else MY_VAL=$MY_WATT; fi
	    if [ ! -z ${MY_VAL+x} ] ; then sudo nvidia-smi -i "$MY_DEVICE" -pl "$MY_VAL" | sed "s/^/  /gi" ; fi;

	done;
fi;

echo

export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100
export CUDA_DEVICE_ORDER=PCI_BUS_ID

# The following setting is available in ethminer since ver 0.13x
# Set it to any value to prevent colored output (useful for log collecting)
# Uncomment the following line if you want to disable colors.

#export NO_COLOR=true

#
# Ethereum Mining
#

# ethminer
# https://github.com/ethereum-mining/ethminer
# Use -G (opencl) or -U (cuda) flag to select GPU platform.
~/ethereum-mining/ethminer/build/ethminer/ethminer --farm-recheck 10000 -U -S "eu1.ethermine.org:4444" -FS "us1.ethermine.org:4444" -O "$MY_ADDRESS.$MY_RIG"

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
#~/zcash-mining/ewbf/miner --fee 0 --server eu1-zcash.flypool.org --user YOUR-ZCASH-T-ADDRESS --pass x --port 3333