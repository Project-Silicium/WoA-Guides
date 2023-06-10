# Installing Windows

Make sure to check the Status of your Device [here](https://github.com/Robotix22/MU-Qcom/blob/main/Status.md).

## Description

This Guide will show you how to install full Windows on your Device.

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Installing Windows
    - [What's needed](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/General/Win.md#needed-things)
    - [Prepare](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/General/Win.md#preparing-step-1)
        - [ISO](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/General/Win.md#windows-image-step-11)
        - [Drivers](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/General/Win.md#windows-drivers-step-12)
    - [Partition UFS](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/General/Win.md#partition-ufs-step-2)
    - [Install](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/General/Win.md#installing-step-3)
    - [Apply Drivers](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/General/Win.md#applying-drivers-step-4)
- [Reinstall Windows](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/General/Win.md#reinstalling-windows)

</td></tr> </table>

## Needed Things:
   - PC / Laptop with Windows (Recommended: Windows 10 or higher)
   - [ADB](https://developer.android.com/studio/releases/platform-tools#downloads)
   - Custom Recovery
   - Unlocked Bootloader
   - [UEFI Image](https://github.com/Robotix22/MU-Qcom)
   - install.wim from an Windows 10/11 ISO
   - [Parted](https://renegade-project.tech/tools/parted.7z)
   - [GDisk](https://renegade-project.tech/tools/gdisk.7z)

## Preparing (Step 1)

## Windows Image (Step 1.1)

I recommend [UUP Dump](https://uupdump.net/) to get a Windows 10/11 ARM64 ISO Image. <br />
Chosse an Build and select all Options you prever. <br />
After that download the zip File and extract it on your PC / Laptop. (The Path should not contain any spaces) <br />
Then Open the extracted Folder and run the Build script, wait once it is finisched. (Some AntiVirus Programms stop the Build) <br />
A ISO will apear in the Folder, open the ISO File and extract the install.wim from `sources` and place it somewhere, where you can reach it.

## Windows Drivers (Step 1.2)

TODO: Add this Section if any Drivers are created for a Device

## Partition UFS (Step 2)

***⚠️ In this Section of the Guide you can easly brick your Device! ⚠️***

Boot into TWRP and unmount `userdata`, then open Command Promt on your PC / Laptop and enter ADB Shell. <br />
Once in ADB Shell create a directory called `worksapce` in `/`:
```
mkdir /workspace/
```
Then extract the .7z Files and push the content with `adb push` into the workspace folder:
```
adb push parted gdisk /workspace/
```
After you copyied parted and gdisk to workspace make it executeable and run parted:
```
chmod 744 parted gdisk
./parted /dev/block/sda
```
Once you executed parted print the partition table:
```
(parted) print
```
Find userdata in output and note the Number, Start and End Address. <br />
Example:
```
(NOTE: Don't use these Values it just an Example!)
Number  Start   End     Size    File system  Name             Flags
38      141GB   241GB   100GB                userdata
```
Once you noted the Number, Start and End Address delete userdata and create esp: <br />
```
# Deleting userdata will wipe all your data in Android!
(parted) rm <Number>
(parted) mkpart esp fat32 <Start> <Start + 512MB>
```
After Creating esp we will create the other Partitions:
```
(parted) mkpart win ntfs <Start 512MB> <Stop / 2>
(parted) mkpart userdata ext4 <Stop / 2> <Stop>
```
Now we set esp to active by running: `set <Number> esp on`. <br />
Once that is done we exit parted and format the partitions:
```
(parted) quit
mkfs.fat -F32 -s1 /dev/block/sda<Number>
mkfs.ntfs -f /dev/block/sda<Number + 1>
mke2fs -t ext4 /dev/block/sda<Number + 2>
```
If formating userdata gives a error reboot to recovery and format userdata in `Delete/Format Data`, click yes. <br />

***⚠️ End of the Dangerous Section! ⚠️***

## Installing (Step 3)

Extract [Mass-Storage.zip](https://github.com/Robotix22/MU-Qcom-Guides/files/11005130/Mass-Storage.zip) and copy it contents to a FAT32 Partition on your Device <br />
After that boot the UEFI Image and select `Continue Boot`, then it enters Windows Boot Manager select `Developer Menu` -> `USB Mass Storage Mode`. <br />
Then connect your Phone to the PC / Laptop and find the Windows and esp partition. <br />
Open diskpart in Command Promt and Find all needed Partitions:
```
DISKPART> lis dis
# you can findout the Phone ID by looking at the Sizes you may regonize your Phone Internal Storage Size
DISKPART> sel dis <Phone ID>
DISKPART> lis par
DISKPART> sel par <ESP ID>
# Use a other Letter if "X" is not availbe
DISKPART> assing letter X
DISKPART> sel par <Win ID>
# Use a other Letter if "R" is not availbe
DISKPART> assing letter R
DISKPART> exit
```
Now we will apply install.wim using dism:
```
# R: Is what we assinged in the diskpart part, replace the letter if you used another letter
dism /apply-image /ImageFile:<Path to install.wim> /index:1 /ApplyDir:R:\
```
After that we need to create the Boot Files other wise our UEFI won't regonise Windows:
```
# R: and X: Is what we assinged in the diskpart part, replace the letter if you used another letter
bcdboot R:\Windows /s X: /f UEFI
```

## Applying Drivers (Step 4)

TODO: Add this Sections if there are any Drivers for a Device.

## Configure BCD (Step 5)

cd into the EFI Partition of your Device and edit some BCD Values:
```
X: Is what we assinged in the diskpart part, replace the letter if you used another letter
cd X:\EFI\Microsoft\Boot
bcdedit /store BCD /set "{default}" testsigning on
bcdedit /store BCD /set "{default}" nointegritychecks on
bcdedit /store BCD /set "{default}" recoveryenabled no
```
After that reboot to recovery and remove Mass Storage, then reboot into UEFI and enjoy your Windows Installation.

## Reinstalling Windows

To reinstall you need [Mass Storage](https://github.com/Robotix22/MU-Qcom-Guides/files/11005130/Mass-Storage.zip) again. <br />
Boot into Mass Storage, plug in your Phone into the PC / Laptop and format the Windows Partition on your Phone to NTFS using the GUI. <br />
After that apply again the install.wim and then, create the boot files again. <br />
Then also apply the BCD Settings again.
