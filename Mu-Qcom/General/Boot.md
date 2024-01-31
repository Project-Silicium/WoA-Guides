# Booting UEFI on your device

## Description

This guide will show you how to boot UEFI on your device.

<table>
<tr><th>Table of contents</th></th>
<tr><td>

- Booting UEFI
    - [Requirements](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/General/Boot.md#recuirements)
    - [Getting UEFI](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/General/Boot.md#getting-uefi)
    - [Method 1](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/General/Boot.md#booting-uefi-method-1-recommended)
    - [Method 2](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/General/Boot.md#flashing-uefi-method-2)
       - [Fastboot](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/General/Boot.md#fastboot)
       - [Odin](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/General/Boot.md#odin)

</td></tr> </table>

## Requirements
   - PC / Laptop
   - Fastboot or Odin depending on your device
   - Unlocked bootloader
   - [UEFI image](https://github.com/Robotix22/Mu-Qcom/releases)

## Getting UEFI

Let's begin with getting the UEFI boot image. <br />
Download the UEFI image or compile a UEFI image, Follow [this](https://github.com/Robotix22/Mu-Qcom/blob/main/Building.md) Guide to compile a UEFI image.

## Booting UEFI (Method 1) [Recommended]

**NOTE: For devices with fastboot only!**

In this method we don't flash anything to the device, We only put the UEFI in RAM and boot from it. <br />
Open a terminal and execute the `fastboot boot` command:
```
fastboot boot <Path to UEFI image>
```
After that your device should boot the UEFI. <br />
Keep in mind that you need to do this everytime you want to boot the UEFI. <br />

## Flashing UEFI (Method 2)

If you don't want to keep executing the command to boot UEFI, this method will show you how to keep the UEFI even after a reboot. <br />
First you should backup your boot partition, which you will need if you decide to remove the UEFI later. <br />
After you backed up the boot partition we can move on to flashing the UEFI. <br />

### Fastboot

Open a terminal and execute the `fastboot flash` command:
```
# NOTE: On A/B Devices you need to add _a or _b at the end of boot depending on what slot you are on
fastboot flash boot <Path to UEFI image>
```

### Odin

If your Device is a Samsung Device you will have to use Odin to flash anything on the device. <br />
First rename the UEFI image to `boot.img` or else Odin won't flash it. <br />
Then you need to compress the UEFI image in a `.tar` file so that Odin can read it. <br />
After that open Odin and select the UEFI image on the AP tab. <br />
Now press start and it will start flashing. <br />
Once that is done it will reboot and boot the UEFI Image.
