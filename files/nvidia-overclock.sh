#!/usr/bin/env bash

#
# nvidia-overclock.sh
# Author: Nils Knieling - https://github.com/Cyclenerd/ethereum_nvidia_miner
#
# Overclocking with nvidia-settings
#
# Changelog
# 2018/03/10 Andrea Lanfranchi - https://github.com/AndreaLanfranchi/ethereum_nvidia_miner
# - Implemented optional per GPU fine tuning
# - Some cosmetic adjustments for nice output
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

export DISPLAY=:0

# Check if we can set power-limit globally (i.e. with only one call to nvidia-smi) 
# or we have to invoke it per GPU
unset MY_WATT_X
if set -o posix; set | grep -q -E "^MY\_WATT\_[0-9]{1,2}" ; then MY_WATT_X="1"; fi;
if [ -z ${MY_WATT_X+x} ]; 
then
	if [ ! -z ${MY_WATT} ] ; 
	then
        printf "\nApplying Power Limit for ALL GPUs \n--------------------------------------------------------------------------------\n" 
	    sudo nvidia-smi -pl "$MY_WATT"
	fi;
fi;

# For each graphics card
nvidia-smi --format=csv,noheader --query-gpu=index | while read -r MY_DEVICE; do

	printf "\n  Processing GPU %s \n  ------------------------------------------------------------------------------\n" "$MY_DEVICE"

	# Init arguments
	# PowerMizer always se
	MY_ARG=" -a \"[gpu:$MY_DEVICE]/GPUPowerMizerMode=1\""
		
	# Clock setting
	MY_VAR="MY_CLOCK_$MY_DEVICE"
	unset MY_VAL
	if [ ! -z ${!MY_VAR} ] ; then MY_VAL=${!MY_VAR}; else MY_VAL=$MY_CLOCK; fi
	if [ ! -z ${MY_VAL} ] ; then MY_ARG+=" -a \"[gpu:$MY_DEVICE]/GPUGraphicsClockOffset[3]=$MY_VAL\""; fi

	# Mem setting
	MY_VAR="MY_MEM_$MY_DEVICE"
	unset MY_VAL
	if [ ! -z ${!MY_VAR} ] ; then MY_VAL=${!MY_VAR}; else MY_VAL=$MY_MEM; fi
	if [ ! -z ${MY_VAL} ] ; then MY_ARG+=" -a \"[gpu:$MY_DEVICE]/GPUMemoryTransferRateOffset[3]=$MY_VAL\""; fi

	# Fan setting
	MY_VAR="MY_FAN_$MY_DEVICE"
	unset MY_VAL
	if [ ! -z ${!MY_VAR} ] ; then MY_VAL=${!MY_VAR}; else MY_VAL=$MY_FAN; fi
	if [ ! -z ${MY_VAL} ] ; then MY_ARG+=" -a \"[fan:$MY_DEVICE]/GPUTargetFanSpeed=$MY_VAL\""; fi
	
	# Apply nvidia-settings
	MY_CMD="nvidia-settings $MY_ARG"
	eval $MY_CMD | grep -E "^  Attr"

	# Eventually apply power limiting per GPU
    if [ ! -z ${MY_WATT_X+x} ]; 
    then 
	
	    MY_VAR="MY_WATT_$MY_DEVICE"
	    unset MY_VAL
	    if [ ! -z ${!MY_VAR} ] ; then MY_VAL=${!MY_VAR}; else MY_VAL=$MY_WATT; fi
		if [ ! -z ${!MY_VAL} ] ; then sudo nvidia-smi -i "$MY_DEVICE" -pl "$MY_VAL" | sed "s/^/  /gi" ; fi;

    fi;
	
done

printf "\n nvidia-overclock Completed !\n\n"

