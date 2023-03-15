# Installing Windows PE

Make sure to check the Status of the Device [here](https://github.com/Robotix22/MU-Qcom/blob/main/Status.md#xiaomi-11t-pro).

<table>
<tr><th>Sections</th></th>
<tr><td>
  
- Installing Windows PE
    - [What's needed](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#what-you-need)
    - [Installing](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#install)
        - [Step 1](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#step-1)
        - [Step 2](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#step-2)
        - [Step 3](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#step-3)
        - [Step 4](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#step-4)
        - [Step 5](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#step-5)
        - [Step 6](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#step-6)
    - [Update Windows PE](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#update-windows-pe)

</td></tr> </table>

## What you need:
   - PC / Laptop
   - [ADB / Fastboot](https://developer.android.com/studio/releases/platform-tools#downloads)
   - Custom Recovery (Recommended: [TWRP](https://sourceforge.net/projects/recovery-for-xiaomi-devices/files/vili/twrp-3.7.0_12-v7.2_A12-vili-skkk.img/download))
   - Unlocked Bootloader
   - [UEFI Image](https://github.com/Robotix22/MU-Qcom)
   - Windows PE (Recommended: [Driverless WinPE](https://drive.google.com/drive/folders/1-k4LwTuVw48e3Es_CIKPNf68CA9HXYRb))

## Install

### Step 1:

Create an workspace and download all [Needed Files](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Xiaomi-11T-Pro/WinPE.md#what-you-need).

### Step 2:

Boot your Device into the Custom Recovery

### Step 3:

Open Terminal on your PC / Laptop and open ADB Shell with:
```
adb shell
```
### Step 4:

Unmount the Cust Partition in the Custom Recovery:
```
umount /cust
```
then in ADB Shell find out what sda Partition Cust is:
```
ls -l /dev/block/by-name
```
you should get an output like this:
```
total 0
lrwxrwxrwx 1 root root 16 1970-07-11 00:01 cust -> /dev/block/sda<Cust ID>
```
Format cust to FAT32: <br />
**DON'T MAKE ANY TYPO IT COULD BRICK YOUR DEVICE IF WRONG PARTITION IS FORMATTED!**
```
mkfs.fat -F32 -s1 /dev/block/sda<Cust ID>
```
Now mount Cust again:
```
mount /dev/block/sda<Cust ID> /cust
```

### Step 5:

Now we need to copy the Windows PE Files into /cust:
```
adb push <Path to WinPE Files> /cust
```

### Step 6:

Boot the UEFI Image with fastboot:
```
fastboot boot <Path to UEFI Image>
```
Now Windows PE should boot.

## Update Windows PE

If you want to Update Windows PE delete all old Windows PE Files and Place the new one in.
