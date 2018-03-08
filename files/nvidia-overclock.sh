#!/usr/bin/env bash

#
# nvidia-overclock.sh
# Author: Nils Knieling - https://github.com/Cyclenerd/ethereum_nvidia_miner
#
# Overclocking with nvidia-settings
#

# Load global settings settings.conf
# shellcheck source=settings.conf
# shellcheck disable=SC1091
if ! source ~/settings.conf; then
	echo "FAILURE: Can not load global settings 'settings.conf'"
	exit 9
fi

export DISPLAY=:0

# For each graphics card
nvidia-smi --format=csv,noheader --query-gpu=index | while read -r MY_DEVICE; do
	# Set Fan speed , Graphics clock, Memory Clock
	nvidia-settings -a "[gpu:$MY_DEVICE]/GPUPowerMizerMode=1" -a "[gpu:$MY_DEVICE]/GPUFanControlState=1" -a "[fan:$MY_DEVICE]/GPUTargetFanSpeed=$MY_FAN" -a "[gpu:$MY_DEVICE]/GPUGraphicsClockOffset[3]=$MY_CLOCK" -a "[gpu:$MY_DEVICE]/GPUMemoryTransferRateOffset[3]=$MY_MEM"
	# Set watt/powerlimit. This is also set in miner.sh at autostart.
	sudo nvidia-smi -i "$MY_DEVICE" -pl "$MY_WATT"
done

echo
echo "Done"
echo
