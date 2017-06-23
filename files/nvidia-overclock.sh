#!/usr/bin/env bash

# Overclocking with nvidia-settings

# GPUGraphicsClockOffset
MY_CLOCK="150"
# GPUMemoryTransferRateOffset
MY_MEM="600"



for MY_DEVICE in {0..6}
do
	DISPLAY=:0 XAUTHORITY=/var/lib/mdm/:0.Xauth nvidia-settings -a "[gpu:$MY_DEVICE]/GPUPowerMizerMode=1"
	DISPLAY=:0 XAUTHORITY=/var/lib/mdm/:0.Xauth nvidia-settings -a "[gpu:$MY_DEVICE]/GPUFanControlState=1"
	DISPLAY=:0 XAUTHORITY=/var/lib/mdm/:0.Xauth nvidia-settings -a "[gpu:$MY_DEVICE]/GPUTargetFanSpeed=80"
	DISPLAY=:0 XAUTHORITY=/var/lib/mdm/:0.Xauth nvidia-settings -a "[gpu:$MY_DEVICE]/GPUGraphicsClockOffset[3]=$MY_CLOCK"
	DISPLAY=:0 XAUTHORITY=/var/lib/mdm/:0.Xauth nvidia-settings -a "[gpu:$MY_DEVICE]/GPUMemoryTransferRateOffset[3]=$MY_MEM"
done

echo "Done"
