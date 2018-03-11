#!/usr/bin/env bash

#
# setup.sh
#
# Author  : Nils Knieling, Andrea Lanfranchi and Contributors 
# Project : https://github.com/Cyclenerd/ethereum_nvidia_miner
#
# Bash Script to automate the configuration for Ethereum mining. Intense use of 'dialog' :-)
#
# Changelog
# 2018/03/11 Andrea Lanfranchi - https://github.com/AndreaLanfranchi/ethereum_nvidia_miner
# - Corrected expensive use of not needed local variables
# - Reorganized menus and actions
# - Inline replacement of settings values (instead of append)
# - Overwrite confirmations on download of updates
# - Sanity checks over input values for overclocking
#


# Common functions
# -------------------------------------------------------------------
function exit_with_failure() {
    echo
    echo "FAILURE: $1"
    echo
    exit 9
}

function command_exists() {
    command -v "$1" >/dev/null 2>&1
}

function pause() {
    read -n1 -r -p "  Press any key to continue..."
}

# check_internet()
function check_internet() {

    # Test availability against Google Public DNS
    if ! ping -c 1 8.8.8.8 >/dev/null 2>&1 then 
        clear
        echo_title "$MY_CHECK_INTERNET_TITLE"
        echo "Network Interfaces"
        ifconfig
        echo
        echo "IP Routing Table"
        route
        echo
        echo "DNS Server"
        cat /etc/resolv.conf
        exit_with_failure "Could not connect to the Internet ('$MY_HTTP_PING_URL')."        
    fi;
    
}


################################################################################
# Terminal output helpers
################################################################################

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
    TITLE=$1
    NCOLS=$(tput cols)
    NEQUALS=$(((NCOLS-${#TITLE})/2-1))
    tput setaf 3 0 0 # 3 = yellow
    echo_equals "$NEQUALS"
    printf " %s " "$TITLE"
    echo_equals "$NEQUALS"
    tput sgr0  # reset terminal
    echo
}

# Actions section
# -------------------------------------------------------------------

# Sets password for prospector user
function action_setpassword() {
    clear
    echo_title "Change prospector's password"
    passwd
    pause
    clear
}

# Change Ethereum Address
function action_ethaddress() {

    # shellcheck disable=SC1091

    # Set dialog 
    MY_DLG_TITLE="Set your Public Ethereum Address"
    MY_DLG_TEXT="
Set your public Ethereum address. 
Allowed characters a-z (upper/lower case) and 0-9.
Ethereum addresses begin with 0x and are 42 characters long.
    "
    # Insensitive casing
    shopt -s nocasematch
    unset cur_value
    unset new_value
    
    cur_value=$(grep -E "^MY_ADDRESS=(.*)$" ~/settings.conf | grep -i -E -o "(0x[a-f0-9]{40})")
    cmd=(dialog --backtitle "$MY_DLG_TITLE" --inputbox "$MY_DLG_TEXT" 14 60 "$cur_value")
    new_value=$("${cmd[@]}" 2>&1 >/dev/tty)
    
    if [ ! -z "$new_value" ]; 
    then 
        clear
        if [[ ! $new_value =~ ^0x[a-f0-9]{40}$ ]]; 
        then
            printf "  Error !\\n\\n  You have entered an invalid Ethereum address.\\n  No changes will be performed.\\n  Please double check and retry.\\n\\n"
        else
            if [ "$cur_value" == "$new_value" ];
            then
                printf "  Warning !\\n\\n  New address is the same of old address.\\n  No changes will be made.\\n\\n"
            else
                sed -i.bak -e "s/MY_ADDRESS=\"\{0,1\}[[:alnum:]]\{0,256\}\"\{0,1\}/MY_ADDRESS=$new_value/gi" ~/settings.conf
                printf "  Ok !\\n\\n  Changes to address have been recorded.\\n  You may want to restart your miner.\\n\\n"
            fi;
        fi;
        
        read -n1 -r -p "  Press any key to continue ..." key
        clear
    fi;
    
}

# Change settings for NVIDIA graphics clock offset
function action_nvidiaclock() {

    # shellcheck disable=SC1091

    # Set dialog 
    MY_DLG_TITLE="Set NVIDIA GPU Graphics Clock Offset"
    MY_DLG_TEXT="
Set Graphics Clock Offset *ALL* NVIDIA graphic cards.
Allowed characters 0-9 and minus sign (-) for negative values.
Good value for GTX 1060 6GB: 150
If you want to refine per GPU then manually edit 'settings.conf'
    "
    # Insensitive casing
    shopt -s nocasematch
    unset cur_value
    unset new_value

    cur_value=$(grep -E "^MY_CLOCK=(.*)$"  ~/settings.conf | grep -io -E "\=(.*)" | grep -io -E "[0-9\-]{1,}")
    cmd=(dialog --backtitle "$MY_DLG_TITLE" --inputbox "$MY_DLG_TEXT" 14 60 "$cur_value")
    new_value=$("${cmd[@]}" 2>&1 >/dev/tty)

    if [ ! -z "$new_value" ]; 
    then 
        clear
        if [[ ! $new_value =~ ^[0-9-]{1,}$ ]]; 
        then
            printf "  Error !\\n\\n  You have entered an invalid clock offset value.\\n  No changes will be performed.\\n  Please double check and retry.\\n\\n"
        else
            if [ "$cur_value" == "$new_value" ];
            then
                printf "  Warning !\\n\\n  New clock offset value is same as old one.\\n  No changes will be made.\\n\\n"
            else
                sed -i.bak -e "s/MY_CLOCK=\"\{0,1\}[[:alnum:]]\{0,256\}\"\{0,1\}/MY_CLOCK=$new_value/gi" ~/settings.conf
                printf "  Ok !\\n\\n  Changes to clock offset have been recorded.\\n  You may want to run nvidia-overclock.\\n\\n"
            fi;
        fi;
        
        read -n1 -r -p "  Press any key to continue ..." key
        clear
    fi;
    
}

# Change settings for NVIDIA memory transfer offset
function action_nvidiamem() {

    # shellcheck disable=SC1091
    
    # Set dialog 
    MY_DLG_TITLE="Set NVIDIA Memory Transfer Rate Offset"
    MY_DLG_TEXT="
Set memory transfer rate offset for *ALL* NVIDIA graphic cards.
Allowed characters 0-9 and decimal point.
Good value for GTX 1060 6GB: 600
If you want to refine per GPU then manually edit 'settings.conf'
    "
    # Insensitive casing
    shopt -s nocasematch
    unset cur_value
    unset new_value
    
    cur_value=$(grep -E "^MY_MEM=(.*)$" ~/settings.conf | grep -io -E "\=(.*)" | grep -io -E "[0-9\-]{1,}")
    cmd=(dialog --backtitle "$MY_DLG_TITLE" --inputbox "$MY_DLG_TEXT" 14 60 "$cur_value")
    new_value=$("${cmd[@]}" 2>&1 >/dev/tty)
    
    if [ ! -z "$new_value" ]; 
    then 
        clear
        if [[ ! $new_value =~ ^(\-)?[0-9]{1,}$ ]]; 
        then
            printf "  Error !\\n\\n  You have entered an invalid memory transfer offset value.\\n  No changes will be performed.\\n  Please double check and retry.\\n\\n"
        else
            if [ "$cur_value" == "$new_value" ];
            then
                printf "  Warning !\\n\\n  New memory transfer offset value is same as old one.\\n  No changes will be made.\\n\\n"
            else
                sed -i.bak -e "s/MY_MEM=\"\{0,1\}-\{0,1\}[[:alnum:]]\{0,256\}\"\{0,1\}/MY_MEM=$new_value/gi" ~/settings.conf
                printf "  Ok !\\n\\n  Changes to memory transfer offset have been recorded.\\n  You may want to run nvidia-overclock.\\n\\n"
            fi;
        fi;
        
        read -n1 -r -p "  Press any key to continue ..." key
        clear
    fi;
    
}

# Change settings for NVIDIA power limit
function action_nvidiapl() {

    # shellcheck disable=SC1091

    # Set dialog 
    MY_DLG_TITLE="Set NVIDIA Power Limit"
    MY_DLG_TEXT="
Set power limit for *ALL* NVIDIA graphic cards. Input in watts (W). 
Allowed characters 0-9 and decimal point.
Good value for GTX 1060 6GB: 70
If you want to refine per GPU then manually edit 'settings.conf'
    "
    # Insensitive casing
    shopt -s nocasematch
    unset cur_value
    unset new_value
    
    cur_value=$(grep -E "^MY_WATT=(.*)$" ~/settings.conf | grep -io -E "\=(.*)" | grep -io -E "[0-9\.]{1,}")
    cmd=(dialog --backtitle "$MY_DLG_TITLE" --inputbox "$MY_DLG_TEXT" 14 60 "$cur_value")
    new_value=$("${cmd[@]}" 2>&1 >/dev/tty)
    
    if [ ! -z "$new_value" ]; 
    then 
        clear
        if [[ ! $new_value =~ ^(\-)?[0-9\.]{1,6}$ ]]; 
        then
            printf "  Error !\\n\\n  You have entered an invalid power value.\\n  No changes will be performed.\\n  Please double check and retry.\\n\\n"
        else
            if [ "$cur_value" == "$new_value" ];
            then
                printf "  Warning !\\n\\n  New power value is same as old one.\\n  No changes will be made.\\n\\n"
            else
                sed -i.bak -e "s/MY_WATT=\"\{0,1\}-\{0,1\}[[:alnum:]]\{0,256\}\"\{0,1\}/MY_WATT=$new_value/gi" ~/settings.conf
                printf "  Ok !\\n\\n  Changes to power limit have been recorded.\\n  You may want to run nvidia-overclock.\\n\\n"
            fi;
        fi;
        
        read -n1 -r -p "  Press any key to continue ..." key
        clear
    fi;
    
}

# Change settings for NVIDIA fan control
function action_nvidiafan() {

    # shellcheck disable=SC1091
    # Set dialog 
    MY_DLG_TITLE="Set NVIDIA GPUs Fan Speed %"
    MY_DLG_TEXT="
Set fan speed (in percent) for *ALL* NVIDIA graphic cards.
Allowed characters 0-9. For security purpouses we accept only
values ranging from 70 to 100 or 0 (zero) in which case the
fan will adjust automatically.
If you want to refine per GPU then manually edit 'settings.conf'
    "
    # Insensitive casing
    shopt -s nocasematch
    unset cur_value
    unset new_value
    
    cur_value=$(grep -E "^MY_FAN=(.*)$" ~/settings.conf | grep -io -E "\=(.*)" | grep -io -E "[0-9]{1,}")
    cmd=(dialog --backtitle "$MY_DLG_TITLE" --inputbox "$MY_DLG_TEXT" 14 60 "$cur_value")
    new_value=$("${cmd[@]}" 2>&1 >/dev/tty)
    
    if [ ! -z "$new_value" ]; 
    then 
        clear
        if [[ ! $new_value =~ ^(7|8|9)[0-9]{1}$|^0$|^100$ ]]; 
        then
            printf "  Error !\\n\\n  You have entered an fan percent value.\\n  No changes will be performed.\\n  Please double check and retry.\\n\\n"
        else
            if [ "$cur_value" == "$new_value" ];
            then
                printf "  Warning !\\n\\n  New fan percent value is same as old one.\\n  No changes will be made.\\n\\n"
            else
                sed -i.bak -e "s/MY_FAN=\"\{0,1\}[[:alnum:]]\{0,256\}\"\{0,1\}/MY_FAN=$new_value/gi" ~/settings.conf
                printf "  Ok !\\n\\n  Changes to fan percent have been recorded.\\n  You may want to run nvidia-overclock.\\n\\n"
            fi;
        fi;
        
        read -n1 -r -p "  Press any key to continue ..." key
        clear
    fi;
    
    
}

# Change Rig's name
function action_rigname() {

    # shellcheck disable=SC1091

    # Set dialog 
    MY_DLG_TITLE="Set your rig name"
    MY_DLG_TEXT="
Enter a name for your machine.
Allowed characters a-z (upper/lower case) and 0-9.
No spaces or punctuations.
    "
    # Insensitive casing
    shopt -s nocasematch
    unset cur_value
    unset new_value
    
    cur_value=$(grep -E "^MY_RIG=(.*)$" ~/settings.conf | grep -io -E "\=(.*)" | grep -io -E "[a-z0-9]{1,}")
    cmd=(dialog --backtitle "$MY_DLG_TITLE" --inputbox "$MY_DLG_TEXT" 14 60 "$cur_value")
    new_value=$("${cmd[@]}" 2>&1 >/dev/tty)

    if [ ! -z "$new_value" ]; 
    then 
        clear
        if [[ ! $new_value =~ ^[a-f0-9]{1,40}$ ]]; 
        then
            printf "  Error !\\n\\n  You have entered an invalid Rig name.\\n  No changes will be performed.\\n  Please double check and retry.\\n\\n"
        else
            if [ "$cur_value" == "$new_value" ];
            then
                printf "  Warning !\\n\\n  New name is the same of old name.\\n  No changes will be made.\\n\\n"
            else
                sed -i.bak -e "s/MY_RIG=\"\{0,1\}[[:alnum:]]\{0,256\}\"\{0,1\}/MY_RIG=$new_value/gi" ~/settings.conf
                printf "  Ok !\\n\\n  Changes to rig name have been recorded.\\n  You may want to restart your miner.\\n\\n"
            fi;
        fi;
        
        read -n1 -r -p "  Press any key to continue ..."
        clear
    fi;
    
    
}

# Instructions for tips
function action_tipme() {

    # Set dialog 
    MY_DLG_TITLE="Would you like to leave a tip ?"
    MY_DLG_TEXT="
With this ISO image, you can immediately mine Ethereum (ETH). Do not spend long time searching and researching.

I would be happy about a small donation. Thank you very much.

Ξ - Ethereum: 0xfbbc9f870bccadf8847eba29b0ed3755e30c9f0d
Ƀ - Bitcoin:  13fQA3mCQPmnXBDSmfautP4VMq6Sj2GVSA
    "
    
    dialog --backtitle "$MY_DLG_TITLE" --msgbox "$MY_DLG_TEXT" 14 65

}

# Manually edit files
function action_nanoedit() {
    clear
    nano -w "$1"
    clear
}

# Shutdown machine
function action_shutdown() {

    # Set dialog 
    MY_DLG_TITLE="Shutdown"
    MY_DLG_TEXT="
Do you really want to shutdown this machine ?
If you're connected remotely machine wont restart !
    "
    
    dialog --backtitle "$MY_DLG_TITLE" --yesno "$MY_DLG_TEXT" 9 60
    case $? in
        0)
            clear
            echo_title "$MY_SHUTDOWN_TITLE"
            sudo shutdown -h now
            exit 0
            ;;
        *)
            ;;
    esac

}

# Shutdown machine
function action_reboot() {

    # Set dialog 
    MY_DLG_TITLE="Reboot"
    MY_DLG_TEXT="
Do you really want to reboot this machine ?
    "
    
    dialog --backtitle "$MY_DLG_TITLE" --yesno "$MY_DLG_TEXT" 9 60
    case $? in
        0)
            clear
            echo_title "$MY_SHUTDOWN_TITLE"
            sudo shutdown -r now
            exit 0
            ;;
        *)
            ;;
    esac

}

# Detects and enable sensors
function action_sensors(){

    MY_SENSORS_DETECT_TITLE="Detect and Generate Monitoring Sensors"

    MY_SENSORS_DETECT_MSG_TEXT="
Detect and generate a list of kernel modules for monitoring temperatures, voltage, and fans.

The program 'sensors-detect' will ask to probe for various hardware. The safe answers are the defaults, so just hitting [Enter] to all the questions will generally not cause any problems.
"

    MY_SENSORS_DETECT_OK_TEXT="
Done! After a reboot, you can use the command 'sensors' to monitor the sensors.
"

    dialog --backtitle "$MY_SENSORS_DETECT_TITLE" --msgbox "$MY_SENSORS_DETECT_MSG_TEXT" 14 60
    clear
    echo_title "$MY_SENSORS_DETECT_TITLE"
    sudo sensors-detect
    pause
    dialog --backtitle "$MY_SENSORS_DETECT_TITLE" --msgbox "$MY_SENSORS_DETECT_OK_TEXT" 7 60
    clear
}

# Sets locale timezone
function action_timezone() {
    clear
    sudo dpkg-reconfigure tzdata
    clear
}

# Sets keyboard locale layout
function action_keyboard() {
    clear
    sudo dpkg-reconfigure keyboard-configuration
    clear
}

# Sets console charset
function action_console() {
    clear
    sudo dpkg-reconfigure console-setup
    clear
}

# Updates relevant scripts
function action_update() {

    clear
    echo_title "Get Latest Updates for relevant files"
    curl -f "https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/update.sh" -o ~/update.sh
    bash ~/update.sh
    rm ~/update.sh
    
    # Set dialog 
    MY_DLG_TITLE="Updates downloaded"
    MY_DLG_TEXT="
All newer version of relevant files has been downloaded.
Do you really want to make them current ?

WARNING ! IF YOU HAVE MADE ANY CHANGES TO ANY OF THESE FILES YOUR
CHANGES WILL BE LOST FOREVER !!

.bashrc 
.screenrc 
bash_aliases 
miner.sh                            (check twice)
nvidia-overclock.sh                 (check twice)
setup.sh 
myip.sh

Even if you respond yes we will ask to confirm every single file.

    "
    
    dialog --backtitle "$MY_DLG_TITLE" --yesno "$MY_DLG_TEXT" 30 70
    case $? in
        0)
            clear
            echo_title "Applying updates ..."
            cd
            cp -i updates/* .
            printf "\\n\\n  All updates processed. Setup needs to be restarted.\\n"
            pause
            exit 0
            ;;
        *)
            ;;
    esac
    
    
}

# Populate xorg.conf file
function action_xorg(){

    # Set dialog 
    MY_DLG_TITLE="Generate Fake Monitors (IMPORTANT!!)"
    MY_DLG_TEXT="
Generate an xorg.conf with faked monitors (for each of your cards).
Absolutely necessary to later overclock the graphics cards!!!11

You need to run this every time you add or remove cards.
"
    dialog --backtitle "$MY_DLG_TITLE" --msgbox "$MY_DLG_TEXT" 10 60
    clear
    echo_title "$MY_DLG_TITLE"
    sudo nvidia-xconfig -a --allow-empty-initial-configuration --cool-bits=31 --use-display-device="DFP-0" --connected-monitor="DFP-0"
    pause
    
    MY_DLG_TEXT="
Done! The computer will now restart.

After restart, connected monitors remain black.

Tip:
If you want to work with the monitor and keyboard after restarting, you can get a console with the key combination [Crtl] + [Alt] + [F1].
"
    
    dialog --backtitle "$MY_DLG_TITLE" --msgbox "$MY_DLG_TEXT" 14 60
    shutdown -f -r now
    exit 0
}


# Menus section
# -------------------------------------------------------------------
function menu_main() {

while true; do

        # Set dialog 
        MY_DLG_TITLE="Main Menu"
        MY_DLG_TEXT="
If you need help, please visit:

    https://github.com/Cyclenerd/ethereum_nvidia_miner

If this is your first time here ensure you got through (at least)
steps 6 and 7.
    
Choose a task:
"

    cmd=(dialog --backtitle "$MY_DLG_TITLE" --menu "$MY_DLG_TEXT" 28 86 16)
    options=(1 "Leave a tip                        - Appreciated"
             2 "Get latest updates                 - Recommended"
             3 "Change default password            - Do it please"
             4 "Change locale settings"
             5 "Detect and generate monitoring sensors"
             6 "Detect your Nvidia GPUs            - Important"
             7 "Configure Miner (ethminer)"
             8 "Configure overclocking and power limits"
             9 "Reboot this machine"
            10 "Shutdown this machine"
            11 "Exit")
            
    choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [ "$choice" != "" ]; then
        case $choice in
            1)  action_tipme ;;
            2)  action_update ;;
            3)  action_setpassword ;;
            4)  menu_localesettings ;;
            5)  action_sensors ;;
            6)  action_xorg ;;
            7)  menu_minersettings ;;
            8)  menu_overclock ;;
            9)  action_reboot ;;
            10) action_shutdown ;;
            11) clear && exit 0;;
        esac
    else
        break
    fi

done
clear

}

function menu_localesettings() {

    while true; do
    
        # Set dialog 
        MY_DLG_TITLE="Configure Locale"
        MY_DLG_TEXT="
Set your locale preferences

Choose a task:
    "

        cmd=(dialog --backtitle "$MY_DLG_TITLE" --menu "$MY_DLG_TEXT" 15 76 16)
        options=(1 "Set your keyboard layout"
                 2 "Set your timezone"
                 3 "Set your console")
        choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        if [ "$choice" != "" ]; then
            case $choice in
                1)  action_keyboard ;;
                2)  action_timezone ;;
                3)  action_console ;;
            esac
        else
            break
        fi
    done

}

function menu_minersettings(){

    while true; do
    
        # Set dialog 
        MY_DLG_TITLE="Configure Miner (ethminer)"
        MY_DLG_TEXT="
By default 'ethminer' mining program and the ethermine.org pool are used.
Here you can set basic values to customize your mining with above mentioned tools.
If you want to change miner program or switch to another pool you will have to
manually edit the file 'miner.sh'

Choose a task:
    "

        cmd=(dialog --backtitle "$MY_DLG_TITLE" --menu "$MY_DLG_TEXT" 25 76 16)
        options=(1 "Set your Ethereum address"
                 2 "Set your rig name"
                 4 "Manually edit 'settings.conf' (for experts)"
                 5 "Manually edit 'miner.sh'      (for experts)" )
        choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        if [ "$choice" != "" ]; then
            case $choice in
                1)  action_ethaddress ;;
                2)  action_rigname ;;
                4)  action_nanoedit ~/settings.conf ;;
                5)  action_nanoedit ~/miner.sh ;;
            esac
        else
            break
        fi
    done
    
}

function menu_overclock() {

        # Set dialog 
        MY_DLG_TITLE="Configure GPU Loads and speed"
        MY_DLG_TEXT="
Configure graphics cards (power limit, clock offset, memory transfer rate offset and fan). The settings apply to all NVIDIA cards! If you want to have different settings per card, you have to adjust the file 'nvidia-overclock.sh'.

Increase or decrease in small increments (+/- 25).

Choose a task:
"

    while true; do
        cmd=(dialog --backtitle "$MY_DLG_TITLE" --menu "$MY_DLG_TEXT" 22 76 16)
        options=(1 "Set or change Power Limit for GPUs"
                 2 "Set or change Graphics Clocks Offset"
                 3 "Set or change Memory Transfer Rate Offset"
                 4 "Set or change Fan percent load"
                 5 "Manually edit 'settings.conf'       (for experts)"
                 6 "Manually edit 'nvidia-overclock.sh' (for experts)")
        choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        if [ "$choice" != "" ]; then
            case $choice in
                1)  action_nvidiapl ;;
                2)  action_nvidiaclock ;;
                3)  action_nvidiamem ;;
                4)  action_nvidiafan ;;
                5)  action_nanoedit ~/settings.conf ;;
                6)  action_nanoedit ~/nvidia-overclock.sh ;;
            esac
        else
            break
        fi
    done

}


#####################################################################
# Check the required programs
#####################################################################

declare -a errors
errors=()
if ! command_exists curl; then errors+=("'curl' is needed. Please install 'curl'."); fi;
if ! command_exists dialog; then errors+=("'dialog' is needed. Please install 'dialog'."); fi;
if ! command_exists nvidia-smi; then errors+=("'nvidia-smi' is needed. Please install 'nvidia-381'."); fi;
if ! command_exists nvidia-xconfig; then errors+=("'nvidia-xconfig' is needed. Please install 'nvidia-381'."); fi;
if ! command_exists nvidia-settings; then errors+=("'nvidia-settings' is needed. Please install 'nvidia-381'."); fi;
if ! command_exists sensors-detect; then errors+=("'sensors-detect' is needed. Please install 'lm-sensors'."); fi;
if ! command_exists sensors; then errors+=("'sensors' is needed. Please install 'lm-sensors'."); fi; 
if ! command_exists git; then errors+=("'git' is needed. Please install 'git'."); fi;
if ! command_exists cmake; then errors+=("'cmake' is needed. Please install 'cmake'."); fi;
if [ ! "${#errors[@]}" == "0" ];
then
    for e in "${errors[@]}"
    do
        echo $e
    done;
    exit 9
fi;
unset errors

# Main entry point
check_internet

# Evantually download a copy of settings.conf if it's missing
if [ ! -f ~/settings.conf ]; then
    echo "Create 'settings.conf'."
    curl -f "https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/settings.conf" -o ~/settings.conf
fi

# Call main menu
menu_main
clear
