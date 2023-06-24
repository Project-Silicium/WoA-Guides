# Fixing UFS

## Description

This Guide will show you how to make UFS usable under Windows and Linux.

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Enabling Mass Storage
   - [What's needed](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Galaxy-Tab-S8-5G/Fix-UFS.md#things-you-need)
   - [Preparing](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Galaxy-Tab-S8-5G/Fix-UFS.md#preparing-step-1)
   - [Fix](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Galaxy-Tab-S8-5G/Fix-UFS.md#fix-ufs-step-2)
     - [Set Online](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Galaxy-Tab-S8-5G/Fix-UFS.md#setting-ufs-online-step-21)
     - [Restore GPT](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Galaxy-Tab-S8-5G/Fix-UFS.md#restoring-ufs-step-22)

</td></tr> </table>

## Things you need:
   - PC / Laptop with Windows 10 or newer
   - [TWRP](https://forum.xda-developers.com/t/recovery-unofficial-twrp-for-galaxy-tab-s8-series-snapdragon.4455491/)
   - Unlocked Bootloader
   - Modded [msc.sh](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Galaxy-Tab-S8-5G/msc.sh) script
   - [GDisk](https://renegade-project.tech/tools/gdisk.7z)

## Preparing (Step 1)

Before we Fix UFS we need to prepare some things. <br />
If you haven't already follow the [Mass Storage](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Galaxy-Tab-S8-5G/Mass-Storage.md) Guide as its needed here. <br />
Make sure you have gdisk on your Tab if not push it to your tab:
```
# External SD recommended
adb push <Path to gdisk> /external_sd/
```
After you pushed gdisk make it executeable:
```
chmod 744 gdisk
```

## Fix UFS (Step 2)

***⚠️ In this Section of the Guide you can easly brick your Device! ⚠️***

## Setting UFS Online (Step 2.1)

Samsung makes by default the UFS LUNs offline on those Devices wich makes UFS unusable under Linux and Windows. <br />
First enter Mass Storage, then open diskmanager on your PC or Laptop. <br />
After that search the Tab Disk, You should find it easy as it has way to many partitions. <br />
Once you found the Disk of your Tab right click it and set it Online. <br />
Now don't panic, Windows set the Disk succesfull to Online but also corrupted the GPT, what ever you do **don't reboot**. <br />

## Restoring GPT (Step 2.2)

Now we need to fix our corrupted GPT as Windows corrupted it. <br />
Open adb shell and execute gdisk:
```
adb shell
./external_sd/gdisk /dev/block/sda
```
Once you executed gdisk it warn you that GPT is corrupted. <br />
To fix that we need to run these following commands: <br />
First enter `r` (recovery and transformation options) after that it will show this output:
```
Recovery/transformation command (? for help):
```
There you need to enter `c` (change a partition's name). <br />
After you did that it will now warn you that some weird things will happen if you do that. <br />
confirm with `y` (Yes), We are almost done, Now we need to write the Tables. <br />
Once the command before finisched enter `w` (write table to disk) also there confirm with `y` (Yes). <br />
gdisk will throw you now out, Your UFS LUN should now be Online and restored to check that Open diskmanager again. <br />

***⚠️ End of the Dangerous Section! ⚠️***

That's it! You successfully Fixed your UFS to make it useable under Windows and Linux.
