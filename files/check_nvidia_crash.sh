#!/usr/bin/env bash

#
# Check if graphic card is crashed and reboot
#
# prospector@mine:~ $ crontab -e
# @hourly bash ~/check_nvidia_crash.sh >/dev/null 2>&1
#

if cat "/var/log/syslog" | grep "NVRM: A GPU crash dump has been created. If possible, please run"; then
	sudo reboot
fi