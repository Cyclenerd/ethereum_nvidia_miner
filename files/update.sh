#!/usr/bin/env bash

#
# update.sh
# Author  : Nils Knieling, Andrea Lanfranchi and Contributors 
# Project : https://github.com/Cyclenerd/ethereum_nvidia_miner
#
# Update files from https://github.com/Cyclenerd/ethereum_nvidia_miner
#

cd ~prospector || exit 9
rm -fr updates

declare -a files
files=(".bashrc" "bash_aliases" ".screenrc" "setup.sh" "miner.sh" "nvidia-overclock.sh" "myip.sh")
if [ ! "${#files[@]}" == "0" ];
then
    for f in "${files[@]}"
    do
        curl -f "https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/${f}" -o "updates/${f}" --create-dirs
    done;
fi;
unset files