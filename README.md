# Ethereum Mining with NVIDIA Graphics Cards and Ubuntu GNU/Linux

🚧 Work in Process 🚧

Press the "Watch" button to get updates. Do not forget the "Star" button :-)


## Set Up

### X11 Configuration with Fake Monitors.

Run `nvidia-config.sh` script.
Generate an xorg.conf with faked monitors (for each of your cards).
You need to run this everytime you add or remove cards

    prospector@mine ~ $ bash nvidia-config.sh


## Fine Tuning

### Overclocking

Start `x11vnc` server.

    prospector@mine ~ $ x11vnc

Run the `nvidia-overclock.sh` script from the terminal within the X session!

    prospector@mine ~ $ bash nvidia-overclock.sh

