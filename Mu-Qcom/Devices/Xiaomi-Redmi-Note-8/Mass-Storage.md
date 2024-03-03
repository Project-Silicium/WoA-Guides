# Enabling Mass Storage

## Description

This Guide will show you how to enable Mass Storage in OrangeFox for Xiaomi Redmi Note 8/8T.

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
   - [OrangeFox](https://orangefox.download/device/ginkgo)
   - Unlocked Bootloader
   - Modded [msc.sh](Resources/msc.sh) script

## Preparing (Step 1)

Okay, First you need to boot into the Custom Recovery (OrangeFox) and then enable MTP if disabled (Mount -> Enable MTP). <br />
Then download the msc.sh script and push it to your Device, For Example to `/cache/`: <br />
```
adb push <Path to msc.sh> /cache/
```

## Enable (Step 2)

After you pushed msc.sh to `/cache/` make it executeable and run it **only once**:
```
adb shell
chmod 755 /cache/msc.sh
./cache/msc.sh
```
There will be some errors in output but that dosen't break anything. <br />
On your PC or Laptop should now show up all the partitions of your Phone from LUN 0.
