# Installing Windows PE

Make sure to check the Status of the Device [here](https://github.com/Robotix22/MU-Qcom/blob/main/Status.md#xiaomi-11t-pro).

## Description

This Guide will show you how to Install Windows PE on your Xiaomi 11T Pro.

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Installing Windows PE
    - [What's needed](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#things-you-need)
    - [Installing](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#installation)
        - [Preparing](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#preparing-step-1)
        - [Formating](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#formating-partitions-step-2)
            - [Find Cust](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#finding-cust-partition-step-21)
            - [Format Cust](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#formating-cust-partition-step-22)
        - [Copy Files](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#copying-windows-pe-files-step-3)
    - [Update Windows PE](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#updating-windows-pe)

</td></tr> </table>

## Things you need:
   - PC / Laptop
   - [ADB and Fastboot](https://developer.android.com/studio/releases/platform-tools#downloads)
   - Custom Recovery (Recommended: [TWRP](https://sourceforge.net/projects/recovery-for-xiaomi-devices/files/vili/twrp-3.7.0_12-v7.2_A12-vili-skkk.img/download))
   - Unlocked Bootloader
   - [UEFI Image](https://github.com/Robotix22/MU-Qcom)
   - Windows PE (Recommended: [Driverless WinPE](https://drive.google.com/drive/folders/1-k4LwTuVw48e3Es_CIKPNf68CA9HXYRb))

## Installation

## Preparing (Step 1)

First of we need to prepare some things before we install Windows PE on our Device. <br />
Make sure you have TWRP installed on your Device and have ADB and Fastboot on your PC / Laptop. <br />
Compile a UEFI Image and place it somewhere on your PC / Laptop where you can find it again. <br />
Download Windows PE and extract the zip File somewhere, where you can reach it.

## Formating Partitions (Step 2)

## Finding Cust Partition (Step 2.1)

Boot into TWRP and plug your Phone into the PC / Laptop. <br />
Open ADB Shell on the Command Promt and find the cust partition:
```
ls -l /dev/block/by-name/ | grep "cust"
```
You should get an output like this:
```
lrwxrwxrwx 1 root root 16 1970-08-14 08:33 cust -> /dev/block/sda<Cust ID>
```
if you get also get `opcust` just ignore that. <br />

## Formating Cust Partition (Step 2.2)

After you found the cust Partition we format it to FAT32:
(**NOTE: If you enter the wrong ID you may brick your Device!**)
```
mkfs.fat -F32 -s1 /dev/block/sda<Cust ID>
```

## Copying Windows PE Files (Step 3)

And now we need to copy the Windows PE Files into cust. <br />
First mount cust in TWRP, then use `adb push` to copy all Windows PE Files to cust:
```
adb push <Path to Windows PE Files> /cust/
```
After that it should contain `sources`, `efi` and `boot`. <br />
You have now successfully installed Windows PE.

## Updating Windows PE

To update Windows PE just delete the old Files and copy all the new Files into cust.
