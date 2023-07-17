# Enabling Mass Storage

## Description

This Guide will show you how to enable Mass Storage in TWRP.

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Enabling Mass Storage
   - [What's needed](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Devices/Galaxy-Tab-S8-5G/Mass-Storage.md#things-you-need)
   - [Preparing](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Devices/Galaxy-Tab-S8-5G/Mass-Storage.md#preparing-step-1)
   - [Enable](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Devices/Galaxy-Tab-S8-5G/Mass-Storage.md#enable-mass-storage-step-2)

</td></tr> </table>

## Things you need:
   - PC / Laptop
   - [TWRP](https://forum.xda-developers.com/t/recovery-unofficial-twrp-for-galaxy-tab-s8-series-snapdragon.4455491/)
   - Unlocked Bootloader
   - Modded [msc.sh](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Devices/Galaxy-Tab-S8-5G/msc.sh) script

## Preparing (Step 1)

Okay first you need to boot into the Custom Recovery (TWRP) and then enable MTP if disabled (Mount -> Enable MTP). <br />
Then download the msc.sh script and push it to your tab like on userdata: <br />
```
adb push <Path to msc.sh> /sdcard/
```

## Enable (Step 2)

After you pushed msc.sh to userdata make it executeable and run it **only once**:
```
adb shell
chmod 744 /sdcard/msc.sh
./sdcard/msc.sh
```
There will be some errors in output but that dosen't break anything. <br />
On your PC or Laptop will now show up the partitions of your Tab from LUN 0.
