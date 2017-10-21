#!/usr/bin/env bash


#
# setup.sh
# Author: Nils Knieling - https://github.com/Cyclenerd/ethereum_nvidia_miner
#
# Bash Script to automate the configuration for ethereum mining. Intense use of 'dialog' :-)
#

#Had nothing to do. Passed by (Trying to understand the art of mining...) and saw your code. I decided to clean it up a bit, and maybe, keep contributing to it later...
#Sincerily, @guekho64 - https://github.com/guekho64
#PD: Long Life To Open Source!

#####################################################################
# gkho64: Let's make translation a bit easier!
#####################################################################

#Default Symbols

defaultSymbols () {
	separatorSymbol=": "
	equalSymbol="="
}

#American English

en_US () {

	#Statuses
	
	fallbackLanguageStatus=1
	languageStatus=1
    
    #Words
    
    wordsNetworkInterfaces="Network Interfaces"
    wordsIPRoutingTable="IP Routing Table"
    wordsDNSServer="DNS Server"

	#Messages
	
	messageFailure="FAILURE"
	messagePressAnyKey="Press any key to continue..."
    messageInternetConnection="There's No Internet Connection..."
    messageCouldNotConnectToTheInternet="Could not connect to the Internet."
    messagePleaseCheckThis="Please check this."
    messageLetsStart="OK, lets start!"
    messageCouldNotConnectToTheInternet2="Could not connect to the Internet ("$MY_HTTP_PING_URL")."
    messageLeaveATip="Leave a Tip"
    messageGetLatestUpdates="Get Latest Updates (Recommended)"
    messageRestartSetup="Done! Please restart 'setup'"
    messageGetLatestUpdates1="Get Latest Updates"
    messageManualEdit="Manual Edit 'settings.conf' (For Experts)"
    messageManualOverclock="Manual Edit 'nvidia-overclock.sh' (For Experts)"
    messageManualMining="Manual Edit 'miner.sh' (For Experts)"
    messageDetectTitle="Detect and Generate Monitoring Sensors"
    messageSensorsOk="Done! After a reboot, you can use the command 'sensors' to monitor the sensors."
    
    #Large Messages
    
    lmessage1MineETH="With this ISO image, you can immediately mine Ethereum (ETH). Do not spend long time searching and researching."
    lmessage1Happy="I would be happy about a small donation. Thank you very much."
    lmessage1ETH="Ξ - Ethereum: 0xfbbc9f870bccadf8847eba29b0ed3755e30c9f0d"
    lmessage1BTC="Ƀ - Bitcoin:  13fQA3mCQPmnXBDSmfautP4VMq6Sj2GVSA"
    
    lmessage2SensorsTxt="Detect and generate a list of kernel modules for monitoring temperatures, voltage, and fans."
    lmessage2SensorsSafe="The programm 'sensors-detect' will ask to probe for various hardware. The safe answers are the defaults, so just hitting [Enter] to all the questions will generally not cause any problems."
}
	
#Mexican Spanish

es_MX () {
	#Estado
	
	languageStatus=1

	#Mensajes
	
	messageFailure="FALLO"
	messagePressAnyKey="Presione cualquier tecla para continuar..."
}

#####################################################################
# Aliases
#####################################################################

#gkho64: Clear is great for quick screen cleanups, BUT, if you have ever seen above, it DOES NOT clear the screen at all, because if you scroll up your terminal (In case of being running the script in a terminal managed by a WM), you'll see all the evidence (Except if "Dialog" takes care of all that trash...).
#gkho64: Another native alternative would be to use "reset", but it's kinda slow clearing the screen, but at least, it gets the job correctly done.
#gkho64: As a third option, we have "tput reset", which does the same, but this one is faster cleaning up the screen, leaving no trace of any previous text. The only counterpart of it, is that, actually, it isn't part of Ubuntu itself nor "coreutils" package, so Ubuntu Server (Or any other distro) may not come preinstalled with it. To workaround that, just make sure to install "ncurses" package. I'll leave that decision to you...

selectScreenCleaner () {
	if [ "$1" -eq 0 ]; then
		alias clearScreen="clear"
	elif [ "$1" -eq 1 ]; then
		alias clearScreen="reset"
	elif [ "$1" -eq 2]; then
		alias clearScreen="tput reset"
	else
		exit 46
	fi
}

#####################################################################
# Startup Functions
#####################################################################

#gkho64: First, let's load stablish a "Screen Cleaner" and load "Default Symbols"

selectScreenCleaner 0
defaultSymbols

#gkho64: Then, let's load a "Language Pack" (For sake of clarity, let's call it like that)
	#gkho64: By default, en_US will be loaded
	
	en_US
	
	#gkho64: Let's make sure that it was properly loaded...
	
	if [ "$fallbackLanguageStatus" -ne 1 ]; then
		exit 640
	fi
	
	#gkho64: Then, the choosen "Language Pack" will "overwrite" the variables set by the default one, effectively creating a "Main" language, and a "Fallback" language, in case of emergency.
	#gkho64: Or even creating a cascade of languages, overwriting its fallback or parent, avoiding double-translations of something that might not need it.
	#gkho64: For example, when translationg from American English to Australian English or British English, being en_US the "parent" of all of them, and voluteers only translationg what REALLY needs to be translated, overwrting only a few strings and not all of them...
	#gkho64: Let the user choose the "Language Pack" to use. Implement it as you want, just make sure that it'll be the first argument when script gets loaded, or let user choose it via "Dialog" (I've never used it, so I'll let you that)
	
	${hereGoesMainLanguagePackName} #gkho64: Or your implemenation of a selection dialog . Just remember that, if users chooses "en_US", just do NOTHING (Except if you're planning to do something else, like showing a "Welcome" screen or something...)
	
	#gkho64: Let's make sure that the selected "Language Pack" was properly loaded...
	
	if [ "$languageStatus" -ne 1 ]; then
		exit 640
	fi

#####################################################################
# Helpers
#####################################################################

# gkho64: I am no expert, but, as far as I know, the "function" keyword and the addition at the end of "()" to a word, both create a function, so writing them both it's not necessary. If you ONLY write "()" instead of "function" (Or vice-versa), code should remain the same and would result in a more readable & portable script...
# gkho64: Also, (In my personal opinion), "echo" isn't a trustworthy program to output text to the user, because many shells (And Linux distros) may "overwrite" or replace the original "echo" program with a version of their own, changing behavior in different environments. I prefer to use "printf" as an alternative, for many other reasons... 

exit_with_failure () {
	reason="$1"
	 printf "\n%s\n\n" "${messageFailure}${separatorSymbol}${reason}"
	 exit 9
}

command_exists () {
	command -v "$1" >/dev/null 2>&1
}

my_any_key () {
	read -n1 -r -p "$messagePressAnyKey"
}

# check_internet()

MY_CHECK_INTERNET_TITLE="$messageInternetConnection"

MY_CHECK_INTERNET_MSG_TEXT="$(printf "\n%s\n\n%s\n\n" "$messageCouldNotConnectToTheInternet" "$messagePleaseCheckThis")"

check_internet () {
	MY_HTTP_PING_URL="https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/README.md"
	if [ "$(curl -f -s "$MY_HTTP_PING_URL")" ]; then
		printf "\n%s\n" "$messageLetsStart" > "/dev/null"
	else
		# ERROR
		
		clearScreen
		dialog --backtitle "$MY_CHECK_INTERNET_TITLE" --msgbox "$MY_CHECK_INTERNET_MSG_TEXT" 7 60
		clearScreen
		echo_title "$MY_CHECK_INTERNET_TITLE"
		printf "\n%s\n" "$wordsNetworkInterfaces"
		ifconfig
		printf "\n\n%s\n" "$wordsIPRoutingTable"
		route
		printf "\n\n%s\n" "$wordsDNSServer"
		cat "/etc/resolv.conf"
		exit_with_failure "$messageCouldNotConnectToTheInternet2"
	fi

}


################################################################################
# Terminal output helpers
################################################################################

# echo_equals() outputs a line with =
echo_equals () {
	COUNTER=0
	while [  $COUNTER -lt "$1" ]; do
		printf "$equalSymbol"
		let COUNTER=COUNTER+1
	done
}

# echo_title() outputs a title padded by =, in yellow.
echo_title () {
	TITLE=$1
	NCOLS=$(tput cols)
	NEQUALS=$(((NCOLS-${#TITLE})/2-1))
	tput setaf 3 0 0 # 3 = yellow
	echo_equals "$NEQUALS"
	printf " %s " "$TITLE"
	echo_equals "$NEQUALS"
	tput sgr0  # reset terminal
	printf "\n\n"
}


#####################################################################
# Menu items
#####################################################################


# my_thank_you()

MY_THANK_YOU_TITLE="$messageLeaveATip"

MY_THANK_YOU_MSG_TEXT="$(printf "\n%s\n\n%s\n\n%s\n%s\n" "$lmessage1MineETH" "$lmessage1Happy" "$lmessage1ETH" "$lmessage1BTC")"

my_thank_you () {
	dialog --backtitle "$MY_THANK_YOU_TITLE" --msgbox "$MY_THANK_YOU_MSG_TEXT" 14 65
}


# my_update()

MY_UPDATE_TITLE="$messageGetLatestUpdates"

MY_UPDATE_OK_TEXT="$(printf "\n\n%s\n\n" "$messageRestartSetup")"

my_update () {
	clearScreen
	echo_title "$messageGetLatestUpdates1"
	curl -f "https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/update.sh" -o ~/update.sh
	bash ~/update.sh
	rm ~/update.sh
	my_any_key
	dialog --backtitle "$MY_UPDATE_TITLE" --msgbox "$MY_UPDATE_OK_TEXT" 7 60
	clearScreen
	printf "\n%s\n" "$MY_UPDATE_OK_TEXT"
	exit 0
}


# my_settings_edit()

MY_SETTINGS_EDIT_TITLE="$messageManualEdit"

my_settings_edit () {
	clearScreen
	echo_title "$MY_SETTINGS_EDIT_TITLE"
	nano -w ~/settings.conf
	clearScreen
}


# my_overclock_edit()

MY_OVERCLOCK_EDIT_TITLE="$messageManualOverclock"

my_overclock_edit () {
	clearScreen
	echo_title "$MY_OVERCLOCK_EDIT_TITLE"
	nano -w ~/nvidia-overclock.sh
	clearScreen
}


# my_miner_edit()

MY_MINER_EDIT_TITLE="$messageManualMining"

my_miner_edit () {
	clearScreen
	echo_title "$MY_MINER_EDIT_TITLE"
	nano -w ~/miner.sh
	clearScreen
}


# my_sensors_detect()

MY_SENSORS_DETECT_TITLE="$messageDetectTitle"

MY_SENSORS_DETECT_MSG_TEXT="$(printf "\n%s\n\n%s\n" "$lmessage2SensorsTxt" "$lmessage2SensorsSafe")"

MY_SENSORS_DETECT_OK_TEXT="$(printf "\n%s\n" "$messageSensorsOk")"

my_sensors_detect () {
	dialog --backtitle "$MY_SENSORS_DETECT_TITLE" --msgbox "$MY_SENSORS_DETECT_MSG_TEXT" 14 60
	clearScreen
	echo_title "$MY_SENSORS_DETECT_TITLE"
	sudo sensors-detect
	my_any_key
	dialog --backtitle "$MY_SENSORS_DETECT_TITLE" --msgbox "$MY_SENSORS_DETECT_OK_TEXT" 7 60
	clearScreen
}


# my_nvidia_config()

MY_NVIDIA_CONFIG_TITLE="$messageGenerateFakeMonitors"

MY_NVIDIA_CONFIG_MSG_TEXT="
Generate an xorg.conf with faked monitors (for each of your cards).

You need to run this everytime you add or remove cards.
"

MY_NVIDIA_CONFIG_OK_TEXT="
Done! The computer will now restart.

After restart, connected monitors remain black.

Tip:
If you want to work with the monitor and keyboard after restarting, you can get a console with the key combination [Crtl] + [Alt] + [F1].
"

function my_nvidia_config(){
	dialog --backtitle "$MY_NVIDIA_CONFIG_TITLE" --msgbox "$MY_NVIDIA_CONFIG_MSG_TEXT" 10 60
	clearScreen
	echo_title "$MY_NVIDIA_CONFIG_TITLE"
	sudo nvidia-xconfig -a --allow-empty-initial-configuration --cool-bits=31 --use-display-device="DFP-0" --connected-monitor="DFP-0"
	my_any_key
	dialog --backtitle "$MY_NVIDIA_CONFIG_TITLE" --msgbox "$MY_NVIDIA_CONFIG_OK_TEXT" 14 60
	my_reboot
}


# my_nvidia_power_limit()

MY_NVIDIA_POWER_LIMIT_TITLE="Set Power Limit"

MY_NVIDIA_POWER_LIMIT_MSG_TEXT="
Set power limit for all NVIDIA grafic cards. Input in watts (W). Allowed characters 0-9.
"
function my_nvidia_power_limit() {
	# shellcheck source=settings.conf
	source ~/settings.conf
	cmd=(dialog --backtitle "$MY_NVIDIA_POWER_LIMIT_TITLE" --inputbox "$MY_NVIDIA_POWER_LIMIT_MSG_TEXT" 14 60 "$MY_WATT")
	choices=$("${cmd[@]}" 2>&1 >/dev/tty)
	if [ "$choices" != "" ]; then
		MY_WATT=$choices
		sed -i.bak '/MY_WATT/d' ~/settings.conf
		echo >> ~/settings.conf
		echo "MY_WATT='$MY_WATT'" >> ~/settings.conf
	fi
}


# my_nvidia_clock()

MY_NVIDIA_CLOCK_TITLE="Set GPU Graphics Clock Offset"

MY_NVIDIA_CLOCK_MSG_TEXT="
Set GPU graphics clock offset (GPUGraphicsClockOffset) for all NVIDIA grafic cards. Allowed characters 0-9 and -.
"
function my_nvidia_clock() {
	# shellcheck source=settings.conf
	source ~/settings.conf
	cmd=(dialog --backtitle "$MY_NVIDIA_CLOCK_TITLE" --inputbox "$MY_NVIDIA_CLOCK_MSG_TEXT" 14 65 "$MY_CLOCK")
	choices=$("${cmd[@]}" 2>&1 >/dev/tty)
	if [ "$choices" != "" ]; then
		MY_CLOCK=$choices
		sed -i.bak '/MY_CLOCK/d' ~/settings.conf
		echo >> ~/settings.conf
		echo "MY_CLOCK='$MY_CLOCK'" >> ~/settings.conf
	fi
}


# my_nvidia_mem()

MY_NVIDIA_MEM_TITLE="Set GPU Memory Transfer Rate Offset"

MY_NVIDIA_MEM_MSG_TEXT="
Set GPU memory transfer rate offset (GPUMemoryTransferRateOffset) for all NVIDIA grafic cards. Allowed characters 0-9.
"
function my_nvidia_mem() {
	# shellcheck source=settings.conf
	source ~/settings.conf
	cmd=(dialog --backtitle "$MY_NVIDIA_MEM_TITLE" --inputbox "$MY_NVIDIA_MEM_MSG_TEXT" 14 60 "$MY_MEM")
	choices=$("${cmd[@]}" 2>&1 >/dev/tty)
	if [ "$choices" != "" ]; then
		MY_MEM=$choices
		sed -i.bak '/MY_MEM/d' ~/settings.conf
		echo >> ~/settings.conf
		echo "MY_MEM='$MY_MEM'" >> ~/settings.conf
	fi
}


# my_nvidia_fan()

MY_NVIDIA_FAN_TITLE="Set GPU Target Fan Speed"

MY_NVIDIA_FAN_MSG_TEXT="
Set GPU target fan speed (GPUTargetFanSpeed) for all NVIDIA grafic cards. Input in percent (%). Allowed characters 0-9.
"
function my_nvidia_fan() {
	# shellcheck source=settings.conf
	source ~/settings.conf
	cmd=(dialog --backtitle "$MY_NVIDIA_FAN_TITLE" --inputbox "$MY_NVIDIA_FAN_MSG_TEXT" 14 60 "$MY_FAN")
	choices=$("${cmd[@]}" 2>&1 >/dev/tty)
	if [ "$choices" != "" ]; then
		MY_FAN=$choices
		sed -i.bak '/MY_FAN/d' ~/settings.conf
		echo >> ~/settings.conf
		echo "MY_FAN='$MY_FAN'" >> ~/settings.conf
	fi
}


# my_nvidia_overclock()

MY_NVIDIA_OVERCLOCK_TITLE="Configure Graphics Cards (Power Limit, Clock Offset, FAN)"

MY_NVIDIA_OVERCLOCK_MENU_TITLE="
Configure graphics cards (power limit, clock offset, memory transfer rate offset and fan). The settings apply to all NVIDIA cards! If you want to have different settings per card, you have to adjust the file 'nvidia-overclock.sh'.

Increase or decrease in small increments (+/- 25).

Choose a task:
"

function my_nvidia_overclock(){
	while true; do
		cmd=(dialog --backtitle "$MY_NVIDIA_OVERCLOCK_MENU_TITLE" --menu "$MY_NVIDIA_OVERCLOCK_MENU_TITLE" 22 76 16)
		options=(1 "$MY_NVIDIA_POWER_LIMIT_TITLE"
		         2 "$MY_NVIDIA_CLOCK_TITLE"
		         3 "$MY_NVIDIA_MEM_TITLE"
		         4 "$MY_NVIDIA_FAN_TITLE"
		         5 "$MY_SETTINGS_EDIT_TITLE"
		         6 "$MY_OVERCLOCK_EDIT_TITLE" )
		choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		if [ "$choice" != "" ]; then
			case $choice in
				1)  my_nvidia_power_limit ;;
				2)  my_nvidia_clock ;;
				3)  my_nvidia_mem ;;
				4)  my_nvidia_fan ;;
				5)  my_settings_edit ;;
				6)  my_overclock_edit ;;
			esac
		else
			break
		fi
	done
}


# my_address()

MY_ADDRESS_TITLE="Set Your Public Ethereum Address"

MY_ADDRESS_MSG_TEXT="
Set your public ethereum address. Allowed characters A-Z and 0-9.
"
function my_address() {
	# shellcheck source=settings.conf
	source ~/settings.conf
	cmd=(dialog --backtitle "$MY_ADDRESS_TITLE" --inputbox "$MY_ADDRESS_MSG_TEXT" 14 60 "$MY_ADDRESS")
	choices=$("${cmd[@]}" 2>&1 >/dev/tty)
	if [ "$choices" != "" ]; then
		MY_ADDRESS=$choices
		sed -i.bak '/MY_ADDRESS/d' ~/settings.conf
		echo >> ~/settings.conf
		echo "MY_ADDRESS='$MY_ADDRESS'" >> ~/settings.conf
	fi
}


# my_rig()

MY_RIG_TITLE="Name Your Rig"

MY_RIG_MSG_TEXT="
Name your rig. Allowed characters A-Z and 0-9.
"
function my_rig() {
	# shellcheck source=settings.conf
	source ~/settings.conf
	cmd=(dialog --backtitle "$MY_RIG_TITLE" --inputbox "$MY_RIG_MSG_TEXT" 14 60 "$MY_RIG")
	choices=$("${cmd[@]}" 2>&1 >/dev/tty)
	if [ "$choices" != "" ]; then
		MY_RIG=$choices
		sed -i.bak '/MY_RIG/d' ~/settings.conf
		echo >> ~/settings.conf
		echo "MY_RIG='$MY_RIG'" >> ~/settings.conf
	fi
}


# my_miner()

MY_MINER_TITLE="Configure Miner (ethminer)"

MY_MINER_MENU_TITLE="
By default, 'ethminer' and the ethermine.org pool are used. If you want to use another program (like Claymore) or pool (like nanopool), you have to adjust the file 'miner.sh'.

Choose a task:
"

function my_miner(){
	while true; do
		cmd=(dialog --backtitle "$MY_MINER_TITLE" --menu "$MY_MINER_MENU_TITLE" 22 76 16)
		options=(1 "$MY_ADDRESS_TITLE"
		         2 "$MY_RIG_TITLE"
		         4 "$MY_SETTINGS_EDIT_TITLE"
		         5 "$MY_MINER_EDIT_TITLE" )
		choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		if [ "$choice" != "" ]; then
			case $choice in
				1)  my_address ;;
				2)  my_rig ;;
				4)  my_settings_edit ;;
				5)  my_miner_edit ;;
			esac
		else
			break
		fi
	done
}


# my_passwd()

MY_PASSWD_TITLE="Change Password"

function my_passwd() {
	clearScreen
	echo_title "$MY_PASSWD_TITLE"
	passwd
	my_any_key
	clearScreen
}


# my_timezone()

MY_TIMEZONE_TITLE="Configure Timezone"

function my_timezone() {
	clearScreen
	sudo dpkg-reconfigure tzdata
	clearScreen
}


# my_keyboard()

MY_KEYBOARD_TITLE="Configure Keyboard"

function my_keyboard() {
	clearScreen
	sudo dpkg-reconfigure keyboard-configuration
	clearScreen
}


# my_console()

MY_CONSOLE_TITLE="Console Setup"

function my_console() {
	clearScreen
	sudo dpkg-reconfigure console-setup
	clearScreen
}


# my_other()

MY_OTHER_TITLE="Other Configuration (do not have to run)"

MY_OTHER_MENU_TITLE="
All steps are optional. All functions should also work without change.

Choose a task:
"

function my_other(){
	while true; do
		cmd=(dialog --backtitle "$MY_OTHER_TITLE" --menu "$MY_OTHER_MENU_TITLE" 22 76 16)
		options=(1 "$MY_KEYBOARD_TITLE"
		         2 "$MY_CONSOLE_TITLE")
		choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
		if [ "$choice" != "" ]; then
			case $choice in
				1)  my_keyboard ;;
				2)  my_console ;;
			esac
		else
			break
		fi
	done
}


# my_reboot()

MY_REBOOT_TITLE="Reboot"

MY_REBOOT_YESNO_TEXT="Do you really want to 'reboot' the computer?"

function my_reboot(){
	dialog --backtitle "$MY_REBOOT_TITLE" --yesno "$MY_REBOOT_YESNO_TEXT" 7 60
	case $? in
		0)
			clearScreen
			echo_title "$MY_REBOOT_TITLE"
			sudo reboot
			;;
		*)
			;;
	esac
}


# my_shutdown()

MY_SHUTDOWN_TITLE="Shutdown"

MY_SHUTDOWN_YESNO_TEXT="Do you really want to 'shutdown' the computer?"

function my_shutdown(){
	dialog --backtitle "$MY_SHUTDOWN_TITLE" --yesno "$MY_SHUTDOWN_YESNO_TEXT" 7 60
	case $? in
		0)
			clearScreen
			echo_title "$MY_SHUTDOWN_TITLE"
			sudo shutdown -h now
			;;
		*)
			;;
	esac
}



#####################################################################
# Check the required programs
#####################################################################

if ! command_exists curl; then
	exit_with_failure "'curl' is needed. Please install 'curl'."
fi

if ! command_exists dialog; then
	exit_with_failure "'dialog' is needed. Please install 'dialog'."
fi

if ! command_exists nvidia-smi; then
	exit_with_failure "'nvidia-smi' is needed. Please install 'nvidia-381'."
fi

if ! command_exists nvidia-xconfig; then
	exit_with_failure "'nvidia-xconfig' is needed. Please install 'nvidia-381'."
fi

if ! command_exists nvidia-settings; then
	exit_with_failure "'nvidia-settings' is needed. Please install 'nvidia-381'."
fi

if ! command_exists sensors-detect; then
	exit_with_failure "'sensors-detect' is needed. Please install 'lm-sensors'."
fi

if ! command_exists sensors; then
	exit_with_failure "'sensors' is needed. Please install 'lm-sensors'."
fi

if ! command_exists git; then
	exit_with_failure "'git' is needed. Please install 'git'."
fi

if ! command_exists cmake; then
	exit_with_failure "'cmake' is needed. Please install 'cmake'."
fi

check_internet

if [ -f ~/settings.conf ]; then
	echo "'settings.conf' found, do not overwrite!"
else
	echo "Create 'settings.conf'."
	curl -f "https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/settings.conf "-o ~/settings.conf
fi


#####################################################################
# Menu
#####################################################################

MY_MENU_TITLE="Setup"

MY_MENU_TEXT="
If you need help, please visit:
    https://github.com/Cyclenerd/ethereum_nvidia_miner

Choose a task:
"

while true; do
	cmd=(dialog --backtitle "$MY_MENU_TITLE" --menu "$MY_MENU_TEXT" 22 76 16)
	options=(1 "$MY_THANK_YOU_TITLE"
	         2 "$MY_UPDATE_TITLE"
	         3 "$MY_PASSWD_TITLE (DO IT!)"
	         4 "$MY_TIMEZONE_TITLE"
	         5 "$MY_SENSORS_DETECT_TITLE"
	         6 "$MY_NVIDIA_CONFIG_TITLE"
	         7 "$MY_MINER_TITLE"
	         8 "$MY_NVIDIA_OVERCLOCK_TITLE"
	         9 "$MY_OTHER_TITLE"
	        10 "$MY_REBOOT_TITLE"
	        11 "$MY_SHUTDOWN_TITLE")
	choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
	if [ "$choice" != "" ]; then
		case $choice in
			1)  my_thank_you ;;
			2)  my_update ;;
			3)  my_passwd ;;
			4)  my_timezone ;;
			5)  my_sensors_detect ;;
			6)  my_nvidia_config ;;
			7)  my_miner ;;
			8)  my_nvidia_overclock ;;
			9)  my_other ;;
			10)  my_reboot ;;
			11) my_shutdown ;;
		esac
	else
		break
	fi
done

clearScreen
