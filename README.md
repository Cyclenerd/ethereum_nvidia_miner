# Ethereum Mining with NVIDIA Graphics Cards and Ubuntu

**USB** flash drive **ISO** image for **Ethereum** mining with **NVIDIA** graphics cards and Ubuntu **GNU/Linux** (64-bit Intel/AMD (x86_64)).

![Ubuntu](https://www.nkn-it.de/img/distro/logos/ubuntu.png)
![NVIDIA](https://www.nkn-it.de/img/logos/nvidia_cuda.jpg)

Press the 👁️ "Watch" button to get updates. Do not forget the  🌟 "Star" button 😀

🚨
**Use at your own risk.**
**Hope to help you.**
**Do not make me responsible for broken hardware.**
🚨


## Introduction

* This ISO image is based on 🐧 **Ubuntu 16.04.2 LTS (Server)**.
* **KISS**, keep it simple, stupid. Only the most necessary included. No 💩 bullshit.
* **NVIDIA** drivers version **381.22** and **CUDA 8** are installed.
* [Genoil's CUDA miner](https://github.com/Genoil/cpp-ethereum) `ethminer` (ethminer-genoil) already compiled and executable.
* Claymore's CUDA miner `ethdcrminer64` is also included.
* Already configured to participate in the [ethermine](https://ethermine.org/) ethereum mining pool.
* The installation is optimized for operation **without monitor** (headless).
* No hard disk drive (HDD/SSD) required. Installation on USB flash drive.
* Created and **tested** with two NVIDIA GTX 1060s.


## Installation

If you do not trust me and do not want to use the image,
you will find all configuration files and scripts in the [files](https://github.com/Cyclenerd/ethereum_nvidia_miner/tree/master/files) folder.
You only have to install an Ubuntu Linux with all the drivers and tools yourself.

If you want to get started quickly, simply use the image.

### Download

Download the ISO image via BitTorrent (`ethereum-ubuntu-nvidia-miner.torrent`).
Compressed 4.7GB, unzipped 30.7GB.

[![Download](https://www.nkn-it.de/img/download_button_200px.png)](https://github.com/Cyclenerd/ethereum_nvidia_miner/raw/master/ethereum-ubuntu-nvidia-miner.torrent)

#### MD5

It is recommended to test that the image is correct and safe to use.
The MD5 calculation gives a checksum, which must equal the MD5 value of a correct ISO image.

| Filename                            | MD5sum                             |
| ----------------------------------- |:----------------------------------:|
| ethereum-ubuntu-nvidia-miner.img.7z | `8b95c462d4d385367489bd2adca0924f` |
| ethereum-ubuntu-nvidia-miner.img    | `bd2f716b4777f49676579ee0917b9a16` |

More help is available here:
https://en.wikipedia.org/wiki/Md5sum

### Copy

1. Unzip the [7zip](http://www.7-zip.org/download.html) file `ethereum-ubuntu-nvidia-miner.img.7z`.
2. Copy the image `ethereum-ubuntu-nvidia-miner.img` to a 32GB USB flash drive.

Larger USB flash drive should also work.
I use the "Sandisk 32GB Ultra Fit USB 3.0 Flash Drive".

The copy can be done with `dd`.  ⚠️ The copy lasts long. Be patient.

How this works exactly is explained to you here:
https://wiki.archlinux.org/index.php/USB_flash_installation_media#Using_dd

#### Under 🍎 macOS it works like this:

Identify the disk (not partition) of your USB flash drive e.g. disk3:

    nils@macbookpro ~ $ diskutil list

Unmount your USB flash drive:

    nils@macbookpro ~ $ diskutil unmountDisk /dev/disk3

Copy the image to your USB flash drive:

    nils@macbookpro ~ $ sudo dd bs=1m if=Downloads/ethereum-ubuntu-nvidia-miner.img of=/dev/rdisk3

Btw. `rdisk3` (with r) not `disk3` is not a write error.



## Set Up

Disable Secure Boot (UEFI) and boot from the USB flash drive.

### Login

The network configuration is done by DHCP. Look in your router which IP your miner has.

Connect via SSH with your miner.

    nils@macbookpro ~ $ ssh prospector@minerIP

Credentials. Password should be changed (`passwd`):

* 👤 Username: `prospector`
* 🔑 Password: `m1n1ng`

### Update

Mistakes happen.
The errors and improvements are posted in this GitHub repository.
Get the latest scripts:

    prospector@mine ~ $ curl "https://raw.githubusercontent.com/Cyclenerd/ethereum_nvidia_miner/master/files/update.sh" -o ~/update.sh
    prospector@mine ~ $ bash update.sh


### Mine

After a minute uptime, a script (`screen`) starts automatically in the background, which starts the mining.

    prospector@mine ~ $ crontab -l
    
    # run screen after reboot
    @reboot sleep 60 && /usr/bin/screen -d -m

Enter `mine` to get it in the foreground:

    prospector@mine ~ $ mine

Use key combination <kbd>Ctrl</kbd> + <kbd>a</kbd>, and subsequently pressing a key to execute one of the commands given below:

* <kbd>n</kbd> : switches to the next available console
* <kbd>p</kbd> : switches back to the previous console
* <kbd>c</kbd> : creates a new virtual Bash console
* <kbd>d</kbd> : detatches the current screen sessions and brings you back to the normal terminal

![htop](https://www.nkn-it.de/img/ethereum_nvidia_miner/mine-top.jpg)
![nvidia-smi](https://www.nkn-it.de/img/ethereum_nvidia_miner/mine-gpu.jpg)
![etherminer](https://www.nkn-it.de/img/ethereum_nvidia_miner/mine-miner.jpg)

More help is available here:
https://help.ubuntu.com/community/Screen

### miner.sh

The `miner.sh` script starts automatically (`mine` console).
In this script you have to make adjustments:

    prospector@mine ~ $ nano -w miner.sh

* Enter your public Ethereum address: `MY_ADDRESS`
* Enter your mining rig name: `MY_RIG`
* Specifies maximum power limit in watts: `MY_WATT`


### X11 Configuration with Fake Monitors.

First of all you should run the `nvidia-config.sh` script and reboot.
This script generates an `xorg.conf` (`/etc/X11/xorg.conf`) with faked monitors (for each of your cards).
You need to run this everytime you add or remove cards.

    prospector@mine ~ $ bash nvidia-config.sh
    prospector@mine ~ $ reboot


## Fine Tuning

To pull the last MH/s out of your cards, you should overclock.

### Overclocking

#### With  nvidia-overclock.sh (nvidia-settings)

Run the `nvidia-overclock.sh` to adjust the memory and graphics clock.
The settings are lost after a restart. You have to repeat it.

    prospector@mine ~ $ bash nvidia-overclock.sh

For safety I did not add it in the autostart (`miner.sh`).
Sometimes you exaggerate when overclocking, and you'll be glad if a simple reboot helps.

You should experiment with the values and adjust the values in the script.
I wish you success 🤓

    prospector@mine ~ $ nano -w nvidia-overclock.sh

#### Why not use nvidia-smi?

nvidia-smi does not work with my cards.

    prospector@mine ~ $ nvidia-smi -i 0 -ac 4004,1987
    Setting applications clocks is not supported for GPU 0000:01:00.0.
    Treating as warning and moving on.
    All done.

No idea if this is a 🐛 bug. Have tried several drivers. Forums are full of bug reports.
With `nvidia-settings` I have no problems.

You can try it with your cards. Here the text from the help:

    -ac, --applications-clocks=MEM_CLOCK,GRAPHICS_CLOCK

> Specifies maximum <memory,graphics> clocks as a pair (e.g. 2000,800) that defines GPU's speed while running applications on a GPU.


### Other things you should do

Set timezone:

    prospector@mine ~ $ sudo dpkg-reconfigure tzdata

Run `sensors-detect` to search for sensors and to generate the necessary kernel modules:

    prospector@mine ~ $ sudo sensors-detect

Delete my SSH public keys:

    prospector@mine ~ $ rm .ssh/authorized_keys

Generating new SSH daemon keys:

    prospector@mine ~ $ sudo ssh-keygen -q -b 8192 -t "ed25519" -f "/etc/ssh/ssh_host_ed25519_key"
    prospector@mine ~ $ sudo ssh-keygen -q -b 8192 -t "rsa" -f "/etc/ssh/ssh_host_rsa_key"

Update ethminer-genoil:

    prospector@mine ~ $ cd cpp-ethereum/
    prospector@mine cpp-ethereum $ git pull
    prospector@mine cpp-ethereum $ cd build/
    prospector@mine build $ cmake -DBUNDLE=cudaminer ..
    prospector@mine build $ make -j8


## Monitoring

Of course, with SSH.
But `munin` and the `lighttpd` web server are also installed. You can use it to access statistics pages.

    http://minerIP/munin

Here you can find diagrams of the sensors, etc.

![munin](https://www.nkn-it.de/img/ethereum_nvidia_miner/munin-sensors.jpg)

### VNC

Start `x11vnc` server.

    prospector@mine ~ $ x11vnc

Enter the IP address and display in VNC Viewer to establish a direct connection. For example:

    minerIP:0

![x11vnc](https://www.nkn-it.de/img/ethereum_nvidia_miner/mine-vnc.jpg)

### Fail2ban

Fail2ban is installed.
The program monitors logins via SSH. Too many false logins from an IP and the IP is blocked.
At each start (reboot) and block you will receive an e-mail.
You should check your e-mails from time to time.

    prospector@mine ~ $ mutt

More help is available here:
https://help.ubuntu.com/community/Fail2ban


## Help 👍

If you have found a bug (English is not my mother tongue) or have any improvements, send me a pull request.


## Leave a Tip 🙏

With the image, you can immediately mine Ethereum.
Do not spend long time searching and researching.

I would be happy about a small donation.

* Ξ - Ethereum: `0xfbbc9f870bccadf8847eba29b0ed3755e30c9f0d`
* Ƀ - Bitcoin: `13fQA3mCQPmnXBDSmfautP4VMq6Sj2GVSA`
