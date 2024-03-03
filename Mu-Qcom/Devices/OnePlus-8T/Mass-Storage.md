# Enabling Mass Storage

## Description

This Guide will show you how to enable Mass Storage in OrangeFox for OnePlus 8T.

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Enabling Mass Storage
   - [What's needed](#things-you-need)
   - [Preparing](#preparing-step-1)
   - [Enable](#enable-mass-storage-step-2)
   - [Driver](#enable-mass-storage-step-2.1)

</td></tr> </table>

## Things you need:
   - PC / Laptop
   - [OrangeFox](https://github.com/Wishmasterflo/android_device_oneplus_kebab/releases/download/V15/OrangeFox-R11.1-Unofficial-OnePlus8T_9R-V15.img)
   - Unlocked Bootloader
   - Modded [msc.sh](Resources/msc.sh) script

## Preparing (Step 1)

Okay, First you need to boot into the Custom Recovery (OrangeFox) and then enable MTP if disabled (Mount -> Enable MTP). <br />
Then download the msc.sh script and push it to your Device, For Example to `/cache/`: <br />
```
adb push <Path to msc.sh> /cache/
```

## Enable (Step 2)

After you pushed msc.sh to `/cache/` make it executeable and run it **only once** , write these commands in a custom recovery terminal:
```
chmod 755 /cache/msc.sh
./cache/msc.sh
```

## Driver (Step 2.1)

If your phone appears in Device Manager as MTP with an exclamation point, then install the driver as shown in the screenshot:
<img align="right" src="Pictures/Install-Driver.png" width="500" alt="Preview">

There will be some errors in output but that dosen't break anything. <br />
On your PC or Laptop should now show up all the partitions of your Phone from LUN 0.
