#!/usr/bin/env bash

# Generate an xorg.conf with faked monitors (for each of your cards)
# You need to run this everytime you add or remove cards.

sudo nvidia-xconfig -a --allow-empty-initial-configuration --cool-bits=31 --use-display-device="DFP-0" --connected-monitor="DFP-0"

echo
echo "Done"
echo
