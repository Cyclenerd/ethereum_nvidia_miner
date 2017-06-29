#!/usr/bin/env bash



# Your public ethereum address
MY_ADDRESS="0xfbbc9f870bccadf8847eba29b0ed3755e30c9f0d"
# Your mining rig name
MY_RIG="mine"

# Specifies maximum power limit in watts.
# Accepts integer and floating point numbers. Only on supported devices from Kepler family.
MY_WATT="120"



sudo nvidia-smi -pm ENABLED
sudo nvidia-smi -pl "$MY_WATT"
echo

export GPU_FORCE_64BIT_PTR=0
export GPU_MAX_HEAP_SIZE=100
export GPU_USE_SYNC_OBJECTS=1
export GPU_MAX_ALLOC_PERCENT=100
export GPU_SINGLE_ALLOC_PERCENT=100

# ethminer-genoil
# https://github.com/Genoil/cpp-ethereum
# Use -G (opencl) or -U (cuda) flag to select GPU platform.
/home/prospector/cpp-ethereum/build/ethminer/ethminer --farm-recheck 200 -U -S "eu1.ethermine.org:4444" -FS "us1.ethermine.org:4444" -O "$MY_ADDRESS.$MY_RIG"

# Claymore's Dual Ethereum+Decred AMD+NVIDIA GPU Miner
# https://github.com/nanopool/Claymore-Dual-Miner
#/home/prospector/claymore-dual-miner/ethdcrminer64 -epool "eu1.ethermine.org:4444" -ewal "$MY_ADDRESS.$MY_RIG" -epsw x -mode 1 -ftime 10 -mport 0 -nofee 1
