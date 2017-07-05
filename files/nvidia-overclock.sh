#!/usr/bin/env bash


# Overclocking with nvidia-settings
# Increase or decrease in small increments (+/- 25)


# GPUGraphicsClockOffset
MY_CLOCK="150"
# GPUMemoryTransferRateOffset
MY_MEM="600"

# GPUTargetFanSpeed (%)
MY_FAN="75"

export DISPLAY=:0

# Graphics card 1 to 6
for MY_DEVICE in {0..5}
do
	# Check if card exists
	if nvidia-smi -i $MY_DEVICE >> /dev/null 2>&1; then
		nvidia-settings -a "[gpu:$MY_DEVICE]/GPUPowerMizerMode=1"
		# Fan speed
		nvidia-settings -a "[gpu:$MY_DEVICE]/GPUFanControlState=1"
		nvidia-settings -a "[fan:$MY_DEVICE]/GPUTargetFanSpeed=$MY_FAN"
		# Grafics clock
		nvidia-settings -a "[gpu:$MY_DEVICE]/GPUGraphicsClockOffset[3]=$MY_CLOCK"
		# Memory clock
		nvidia-settings -a "[gpu:$MY_DEVICE]/GPUMemoryTransferRateOffset[3]=$MY_MEM"
	fi
done

echo
echo "Done"
echo
