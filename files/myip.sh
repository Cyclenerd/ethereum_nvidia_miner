#!/usr/bin/env bash

ip=$(curl -s https://api.ipify.org)
echo "My public IP address is: $ip"

