# Frequently Asked Questions

You asked a lot of questions to me.
Here is a collection of the most common.

## I am a complete Linux n00b. Should I use your ISO image?

No. You should be able to safely use Linux.

## I am an absolute Windows fanboy. Should I use your ISO image?

No. Stay with your favorite operating system.
And please also do not send me e-mails how much better your Windows is.

## I miss this and that. Can you add it?

No. I published the ISO image to make the start easier for you.
But I do not take away all your work.

## Does the ISO image work with AMD cards?

No. Only NVIDIA with CUDA.

## Does the ISO image work in the GTX 1080?

Yes. NVIDIA driver 381.22 is installed.

## Can I mix cards?

Yes. You can combine any NVIDIA cards to a mining rig.
You have to adjust the `nvidia-overclock.sh` script.
But you should do that anyway.

## Do I need an HDMI dongle?

NO. Fake monitors are configured by software.

## I get less MH/s with your ISO image.

Then you're doing something wrong. Many users reported similar or better MH/s values.

## My connected monitor stays black. Why?

The ISO image is optimized for operation with no monitor (headless).
The `setup` script creates fake monitors.
As soon as the X server is started, there is no longer any real output.
If you want to work with the monitor and keyboard after restarting, you can get a console with the key combination
<kbd>Crtl</kbd> + <kbd>Alt</kbd> + <kbd>F1</kbd>.

## Overclocking does not work. Why?

It is extremely important that the X server is running on each of your NVIDIA cards.

The output of `nvidia-smi` must look something like this:

```
prospector@mine ~ $ nvidia-smi
Sat Jul  8 20:24:29 2017
+-----------------------------------------------------------------------------+
| NVIDIA-SMI 381.22                 Driver Version: 381.22                    |
|-------------------------------+----------------------+----------------------+
| GPU  Name        Persistence-M| Bus-Id        Disp.A | Volatile Uncorr. ECC |
| Fan  Temp  Perf  Pwr:Usage/Cap|         Memory-Usage | GPU-Util  Compute M. |
|===============================+======================+======================|
|   0  GeForce GTX 106...  On   | 0000:01:00.0      On |                  N/A |
| 70%   64C    P2    70W /  70W |   2207MiB /  6072MiB |    100%      Default |
+-------------------------------+----------------------+----------------------+
|   1  GeForce GTX 106...  On   | 0000:07:00.0      On |                  N/A |
| 70%   56C    P2    70W /  70W |   2206MiB /  6072MiB |    100%      Default |
+-------------------------------+----------------------+----------------------+
```

Display 0 must be an NVIDIA card!
Set this in your mainboard settings.
Disable to be safe all other graphics cards.
The output of `lspci` should look like this. Only NVIDIA cards:

```
prospector@mine ~ $ lspci | grep VGA
01:00.0 VGA compatible controller: NVIDIA Corporation Device 1c03 (rev a1)
07:00.0 VGA compatible controller: NVIDIA Corporation Device 1c03 (rev a1)
```

## How do I get information about my cards?

Check the settings:

```
prospector@mine ~ $ nvidia-smi --format=csv --query-gpu=name,power.draw,fan.speed,temperature.gpu,clocks.video,clocks.mem
name, power.draw [W], fan.speed [%], temperature.gpu, clocks.current.video [MHz], clocks.current.memory [MHz]
GeForce GTX 1060 6GB, 68.54 W, 70 %, 62, 1202 MHz, 4404 MHz
GeForce GTX 1060 6GB, 70.50 W, 70 %, 55, 1354 MHz, 4404 MHz
```

Check which cards have been detected:

```
prospector@mine ~ $ lspci | grep VGA
01:00.0 VGA compatible controller: NVIDIA Corporation Device 1c03 (rev a1)
07:00.0 VGA compatible controller: NVIDIA Corporation Device 1c03 (rev a1)
```

## Can I use the GitHub Issues for discussion?

No Please not. Search for a forum.
[Reddit](https://www.reddit.com/r/EtherMining/) is a good place for it.
If you have Linux questions, Google it and then you can ask questions at [Stack Overflow](https://stackoverflow.com/).
Everything better places than here.
I will not participate in discussions.
The issue can be closed at any time by me.

## Can I customize the script?

Yes. Configure everything to your needs.