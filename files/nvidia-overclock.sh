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
# Set persistence mode
nvidia-smi -pm ENABLED
# Get total number of grafics cards
NUMGPU="$(nvidia-smi -L | wc -l)"
NUMGPU=$(( $NUMGPU - 1))

# Graphics card 1 to max
for (( MY_DEVICE=0 ; MY_DEVICE <= NUMGPU ; 1 ))
do
	# Check if card exists
	if nvidia-smi -i $MY_DEVICE >> /dev/null 2>&1; then
	        # Set Fan speed , Graphics clock, Memory Clock
		nvidia-settings -a "[gpu:$MY_DEVICE]/GPUPowerMizerMode=1" -a "[gpu:$MY_DEVICE]/GPUFanControlState=1" -a "[fan:$MY_DEVICE]/GPUTargetFanSpeed=$MY_FAN" -a "[gpu:$MY_DEVICE]/GPUGraphicsClockOffset[3]=$MY_CLOCK" -a "[gpu:$MY_DEVICE]/GPUMemoryTransferRateOffset[3]=$MY_MEM"
		# Set watt/powerlimit. This is also set in miner.sh at autostart.
		sudo nvidia-smi -i "$MY_DEVICE" -pl "$MY_WATT"
	fi
	MY_DEVICE=$(( $MY_DEVICE + 1))
done

echo
echo "Done"
echo
