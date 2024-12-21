# Booting UEFI on your Device

## Description

This Guide will show your how to boot UEFI on your Device.

<table>
<tr><th>Table of Contents</th></th>
<tr><td>

- Booting UEFI
    - [Requirements](#recuirements)
    - [Getting UEFI](#getting-uefi)
    - [Method 1](#booting-uefi-method-1-recommended)
    - [Method 2](#flashing-uefi-method-2)
       - [Fastboot](#fastboot)
       - [Odin](#odin)

</td></tr> </table>

## Requirements
   - PC / Laptop
   - Fastboot or Odin depending on your Device
   - Unlocked Bootloader
   - [UEFI Image](https://github.com/Robotix22/Mu-Qcom/releases)

## Getting UEFI

Let's begin with getting the UEFI Boot Image. <br />
Download the UEFI Image or compile a UEFI Imageu using [this](https://github.com/Robotix22/Mu-Qcom/blob/main/Building.md) Guide.

## Booting UEFI (Method 1) [Recommended]

**NOTE: For Devices with fastboot only!**

In this Method we don't flash the Device, We only put UEFI in RAM and boot from it. <br />
Open a Terminal and execute the `fastboot boot` command:
```
fastboot boot <Path to UEFI Image>
```
After that your Device should boot UEFI. <br />
Keep in mind that you need to do that everytime if you want to boot UEFI. <br />

## Flashing UEFI (Method 2)

If you don't wanna keep executing the command to boot UEFI, this Method will show you how to Keep UEFI even after Reboot. <br />
First you should backup your Boot Partition if you decide to remove UEFI. <br />
After you backed up the Boot Partition we can move on to flashing UEFI. <br />

### Fastboot

Open a Terminal and execute the `fastboot flash` command:
```
# NOTE: On A/B Devices you need to add _a or _b at the end of boot depending on what Slot you are
fastboot flash boot <Path to UEFI Image>
```

### Odin

If your Device is a Samsung Device you probally use Odin to flash the Device. <br />
First rename the UEFI Image to `boot.img` or else Odin won't flash it. <br />
Then you need to compress the UEFI Image in a `.tar` File so that Odin can read it. <br />
After that Open Odin and select the UEFI Image on tha AP Tab. <br />
Now press Start and it will start Flashing. <br />
Once that is done it will reboot and boot the UEFI Image.