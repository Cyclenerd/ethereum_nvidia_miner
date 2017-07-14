#!/usr/bin/env bash

#
# nvidia-overclock.sh
# Author: Nils Knieling - https://github.com/Cyclenerd/ethereum_nvidia_miner
#
# Overclocking with nvidia-settings
#

# Load global settings settings.conf
if ! source ~/settings.conf; then
	echo "FAILURE: Can not load global settings 'settings.conf'"
	exit 9
fi

export DISPLAY=:0

# Count the number of nvidia cards in /dev
NVDEVS=`lspci | grep -i NVIDIA`
N3D=`echo "$NVDEVS" | grep "3D controller" | wc -l`
NVGA=`echo "$NVDEVS" | grep "VGA compatible controller" | wc -l`
N=`expr $N3D + $NVGA - 1`
echo $N devices found

for MY_DEVICE in `seq 0 $N` ; do
do
	# Card exists.  Set Power Mizer.
	nvidia-settings -a "[gpu:$MY_DEVICE]/GPUPowerMizerMode=1"
	# Fan speed
	nvidia-settings -a "[gpu:$MY_DEVICE]/GPUFanControlState=1"
	nvidia-settings -a "[fan:$MY_DEVICE]/GPUTargetFanSpeed=$MY_FAN"
	# Graphics clock
	nvidia-settings -a "[gpu:$MY_DEVICE]/GPUGraphicsClockOffset[3]=$MY_CLOCK"
	# Memory clock
	nvidia-settings -a "[gpu:$MY_DEVICE]/GPUMemoryTransferRateOffset[3]=$MY_MEM"
done

echo
echo "Done"
echo
