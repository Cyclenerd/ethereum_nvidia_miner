#!/usr/bin/env bash

#Skip manual settings per card.
SKIP_MANUAL_SETTINGS=true
# GPUGraphicsClockOffset
MY_CLOCK="150"
# GPUMemoryTransferRateOffset
MY_MEM="600"
# GPUTargetFanSpeed (%)
MY_FAN="85"

LINE_COUNT="$(nvidia-smi -L | wc -l)"
for (( MY_DEVICE = 0; MY_DEVICE < ${LINE_COUNT}; MY_DEVICE++ )); do
    FIX_LINE_NUMBER="$(expr $MY_DEVICE + 1)"
    GPU_NAME="$(nvidia-smi --query-gpu=gpu_name --format=csv,noheader | sed -n ${FIX_LINE_NUMBER}p)"
    # Enable control of offsets.
    DISPLAY=:0 XAUTHORITY=/var/lib/mdm/:0.Xauth nvidia-settings -a "[gpu:$MY_DEVICE]/GPUPowerMizerMode=1"
    # Enable fan speed control.
    DISPLAY=:0 XAUTHORITY=/var/lib/mdm/:0.Xauth nvidia-settings -a "[gpu:$MY_DEVICE]/GPUFanControlState=1"

    if [ $SKIP_MANUAL_SETTINGS = false ]; then
        echo "Enter clock speed offset for GPU:$MY_DEVICE (${GPU_NAME}) [Press enter/return to skip. | Don't include the + symbol.]"
        read CLOCK_OFFSET
        if ! [ "$CLOCK_OFFSET" -eq "$CLOCK_OFFSET" ] 2> /dev/null; then
            CLOCK_OFFSET=$MY_CLOCK
            echo "Manual clock speed offset for GPU:$MY_DEVICE (${GPU_NAME}) skipped. Using +$CLOCK_OFFSET"
        fi
        echo
        echo "Enter memory speed offset for GPU:$MY_DEVICE (${GPU_NAME}) [Press enter/return to skip. | Don't include the + symbol.]"
        read MEM_OFFSET
        if ! [ "$MEM_OFFSET" -eq "$MEM_OFFSET" ] 2> /dev/null; then
            MEM_OFFSET=$MY_MEM
            echo "Manual memory speed offset for GPU:$MY_DEVICE (${GPU_NAME}) skipped. Using +$MEM_OFFSET"
        fi
        echo
        echo "Enter fan speed percentage for GPU:$MY_DEVICE (${GPU_NAME}) [Press enter/return to skip. | Don't include the % symbol.]"
        read FAN_PERCENT
        if ! [ "$FAN_PERCENT" -eq "$FAN_PERCENT" ] 2> /dev/null; then
            FAN_PERCENT=$MY_FAN
            echo "Manual fan speed percentage for GPU:$MY_DEVICE (${GPU_NAME}) skipped. Using $FAN_PERCENT%"
        fi
    else
        CLOCK_OFFSET=$MY_CLOCK
        MEM_OFFSET=$MY_MEM
        FAN_PERCENT=$MY_FAN
    fi
    DISPLAY=:0 XAUTHORITY=/var/lib/mdm/:0.Xauth nvidia-settings -a "[gpu:$MY_DEVICE]/GPUGraphicsClockOffset[3]=$CLOCK_OFFSET"
    DISPLAY=:0 XAUTHORITY=/var/lib/mdm/:0.Xauth nvidia-settings -a "[gpu:$MY_DEVICE]/GPUMemoryTransferRateOffset[3]=$MEM_OFFSET"
    DISPLAY=:0 XAUTHORITY=/var/lib/mdm/:0.Xauth nvidia-settings -a "[fan:$MY_DEVICE]/GPUTargetFanSpeed=$FAN_PERCENT"
    echo
done
