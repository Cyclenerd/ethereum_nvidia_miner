#!/usr/bin/env bash

# Run the this script from the terminal within the X session !!!
# Use 'x11vnc' to duplicates the first display (x0) to vnc.



# GPUGraphicsClockOffset
MY_CLOCK="150"
# GPUMemoryTransferRateOffset
MY_MEM="600"



for MY_DEVICE in {0..6}
do
	sudo nvidia-settings -a "[gpu:$MY_DEVICE]/GPUPowerMizerMode=1"
	sudo nvidia-settings -a "[gpu:$MY_DEVICE]/GPUFanControlState=1"
	sudo nvidia-settings -a "[gpu:$MY_DEVICE]/GPUTargetFanSpeed=80"
	sudo nvidia-settings -a "[gpu:$MY_DEVICE]/GPUGraphicsClockOffset[3]=$MY_CLOCK"
	sudo nvidia-settings -a "[gpu:$MY_DEVICE]/GPUMemoryTransferRateOffset[3]=$MY_MEM"
done

echo "Done"
