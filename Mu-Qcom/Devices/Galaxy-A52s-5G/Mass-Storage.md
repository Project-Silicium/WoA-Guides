# Enabling Mass Storage

## Description

This Guide will show you how to enable Mass Storage in TWRP for the Galaxy A52s 5G.

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Enabling Mass Storage
   - [What's needed](#things-you-need)
   - [Preparing](#preparing-step-1)
   - [Enable](#enable-mass-storage-step-2)

</td></tr> </table>

## Things you need:
   - PC / Laptop
   - [TWRP](https://twrp.me/samsung/samsunggalaxya52s5G.html)
   - Unlocked Bootloader
   - Modded [msc.sh](Resources/msc.sh) script

## Preparing (Step 1)

Okay, First you need to boot into the Custom Recovery (TWRP) and then enable MTP if disabled (Mount -> Enable MTP). <br />
Then download the msc.sh script and push it to your Device, For Example to `/sdcard/`: <br />
```
adb push <Path to msc.sh> /sdcard/
```

## Enable (Step 2)

After you pushed msc.sh to `/sdcard/` make it executeable and run it **only once**:
```
adb shell
chmod 744 /sdcard/msc.sh
./sdcard/msc.sh
```
There will be some errors in output but that dosen't break anything. <br />
On your PC or Laptop should now show up all the partitions of your Tab from LUN 0.
