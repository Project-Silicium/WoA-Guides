# Enabling Mass Storage

## Description

This Guide will show you how to enable Mass Storage in Android with root for Realme GT NEO 2.

> NOTE: You can use custom recovery like OrangeFox if it supports your android version

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
   - Modded [msc.sh](Resources/msc.sh) script

## Preparing (Step 1)

Okay, First you need to boot into Android <br />
Then download the msc.sh script and push it to your Device, For Example to `/sdcard/`: <br />
```
adb push <Path to msc.sh> /sdcard/
```

## Enable (Step 2)

After you pushed msc.sh to `/sdcard/` copy it to `/cache/` make it executable and run it **only once** , write these commands in a adb shell:
```
su
cp /sdcard/msc.sh  /cache/
chmod 755 /cache/msc.sh
./cache/msc.sh
```

After that, the adb shell should disconnect and a `Linux File-Stor Gadget` device should be connected.