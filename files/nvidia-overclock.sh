#!/usr/bin/env bash

#
# nvidia-overclock.sh
# Author: Nils Knieling, Andrea Lanfranchi and Contributors- https://github.com/Cyclenerd/ethereum_nvidia_miner
#
# Overclocking with nvidia-settings
#

#####################################################################
# Helpers
#####################################################################

# echo_failure() outputs FAILURE with text
function exit_with_failure() {
    printf "\\nFAILURE: %s\\n\\n" "$1"
    exit 9
}

# echo_equals() outputs a line with =
function echo_equals() {
    COUNTER=0
    while [  $COUNTER -lt "$1" ]; do
        printf '='
        (( COUNTER=COUNTER+1 ))
    done
}

# echo_title() outputs a title padded by =, in yellow.
function echo_title() {
    TITLE="$1"
    NCOLS=$(tput cols)
    NEQUALS=$(((NCOLS-${#TITLE})/2-1))
    tput setaf 3 0 0 # 3 = yellow
    echo_equals "$NEQUALS"
    printf " %s " "$TITLE"
    echo_equals "$NEQUALS"
    tput sgr0  # reset terminal
    echo
}

#####################################################################
# MAIN
#####################################################################

# Load global settings settings.conf
# shellcheck source=settings.conf
# shellcheck disable=SC1091
if ! source ~/settings.conf; then
    exit_with_failure "Can not load global settings 'settings.conf'"
fi

export DISPLAY=:0

# Power only?
case "$1" in
"")
    # called without arguments
    ;;
"powerlimit")
    MY_POWER_ONLY="1"
    ;;
esac

# Set the  persistence mode for all GPUs
echo_title "Set Persistence Mode for ALL GPUs" 
sudo nvidia-smi -pm ENABLED | sed "s/^/  /gi"

# Check if we can set power-limit globally (i.e. with only one call to nvidia-smi) 
# or we have to invoke it per GPU
unset MY_WATT_X
if set -o posix; set | grep -q -E "^MY\\_WATT\\_[0-9]{1,2}" ; then MY_WATT_X="1"; fi;
if [ -z "${MY_WATT_X+x}" ]; then
    MY_VAR="MY_WATT"
    unset MY_VAL
    if [ ! -z "${!MY_VAR}" ] ; then MY_VAL="${!MY_VAR}"; fi;
    if [ ! -z "${MY_VAL+x}" ] ; 
    then
        echo_title "Applying Power Limit for ALL GPUs" 
        sudo nvidia-smi -pl "$MY_VAL" | sed "s/^/  /gi"
    fi;
fi;

# For each graphics card
nvidia-smi --format=csv,noheader --query-gpu=index | while read -r MY_DEVICE; do
    echo_title "Processing GPU $MY_DEVICE"
    
    # Eventually apply power limiting per GPU
    if [ ! -z "${MY_WATT_X+x}" ]; then
        MY_VAR="MY_WATT_$MY_DEVICE"
        unset MY_VAL
        if [ ! -z "${!MY_VAR}" ]; then
            MY_VAL="${!MY_VAR}"
        else 
            MY_VAR="MY_WATT"
            if [ ! -z "${!MY_VAR}" ] ; then MY_VAL="${!MY_VAR}"; fi;
        fi;
        if [ ! -z "${MY_VAL+x}" ] ; then sudo nvidia-smi -i "$MY_DEVICE" -pl "$MY_VAL" | sed "/All done./d;s/^/  /gi" ; fi;
    fi;
    
    # Overclocking
    if [ -z "$MY_POWER_ONLY" ]; then
        # Init arguments
        # PowerMizer always set
        MY_ARG=" -a \"[gpu:$MY_DEVICE]/GPUPowerMizerMode=1\""
        # Clock setting
        MY_VAR="MY_CLOCK_$MY_DEVICE"
        unset MY_VAL
        if [ ! -z "${!MY_VAR}" ] ; then MY_VAL="${!MY_VAR}"; else MY_VAL="$MY_CLOCK"; fi
        if [ ! -z "${MY_VAL+x}" ] ; then MY_ARG+=" -a \"[gpu:$MY_DEVICE]/GPUGraphicsClockOffset[3]=$MY_VAL\""; fi
        # Mem setting
        MY_VAR="MY_MEM_$MY_DEVICE"
        unset MY_VAL
        if [ ! -z "${!MY_VAR}" ] ; then MY_VAL="${!MY_VAR}"; else MY_VAL="$MY_MEM"; fi
        if [ ! -z "${MY_VAL+x}" ] ; then MY_ARG+=" -a \"[gpu:$MY_DEVICE]/GPUMemoryTransferRateOffset[3]=$MY_VAL\""; fi
        # Fan setting
        MY_VAR="MY_FAN_$MY_DEVICE"
        unset MY_VAL
        if [ ! -z "${!MY_VAR}" ] ; then MY_VAL="${!MY_VAR}"; else MY_VAL="$MY_FAN"; fi
        if [ ! -z "${MY_VAL+x}" ] ; then MY_ARG+=" -a \"[fan:$MY_DEVICE]/GPUTargetFanSpeed=$MY_VAL\""; fi
        # Apply nvidia-settings
        MY_CMD="nvidia-settings $MY_ARG"
        eval "$MY_CMD" | grep -E "^  Attr"
    fi;
    
    printf "  All done.\\n"
done

printf "\\nnvidia-overclock Completed!\\n\\n"

