# Arch Linux ARM

Make sure to check the Status of your Device [here](https://github.com/Robotix22/Mu-Qcom/blob/main/Status.md).

## Description

This Guide will show you how to Arch Linux Arm on your Device.
You can either use build-in UFS storage or external USB device.

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Installing Windows
    - [What's needed](#needed-things)
    - Partition Installation Device (Step 1)
        - [Partition UFS](#partition-ufs)
        - [Partition USB](#partition-usb)
    - [Install](#installing-system-step-3)
    - [Install Bootloader](#installing-and-configuring-refind-step-4)
    - [Things to do post install](#things-to-do-post-installation)

</td></tr> </table>

## Needed Things:
   - PC / Laptop with Linux (VM can be used / WSL to be tested)
   - Unlocked Bootloader
   - [UEFI Image](https://github.com/Robotix22/Mu-Qcom)
   - [Generic Arch Linux Arm image](https://archlinuxarm.org/platforms/armv8/generic)
   - [rEFInd](https://sourceforge.net/projects/refind/files/0.14.0.2/refind-bin-0.14.0.2.zip/download)

   `If using UFS`
   - Custom Recovery
   - [ADB](https://developer.android.com/studio/releases/platform-tools#downloads)
   - [Parted](https://renegade-project.tech/tools/parted.7z)
   - [GDisk](https://renegade-project.tech/tools/gdisk.7z)

## Partition UFS
***⚠️ In this Section of the Guide you can easly brick your Device! ⚠️***

***⚠️ NOTE: UNTESTED YOU DO IT AT YOUR OWN RISK (It should theoretically work) ⚠️***

***⚠️ IF YOU DON'T KNOW WHAT ARE YOU DOING USE [USB METHOD](#partition-usb) INSTEAD ⚠️***


Boot into your Custom Recovery and unmount `userdata`, then open Command Promt on your PC / Laptop and enter ADB Shell. <br />
Once in ADB Shell create a directory called `worksapce` in `/`:
```
mkdir /workspace/
```
Then extract the .7z Files and push the content with `adb push` into the workspace folder:
```
adb push parted gdisk /workspace/
```
After you copied parted and gdisk to workspace make it executeable and run parted:
```
# NOTE: If your device has memory type eMMC, instead of sda use mmcblk0!
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
# NOTE: Don't use these Values it just an Example!
Number  Start   End     Size    File system  Name             Flags
38      141GB   241GB   100GB                userdata
```
Once you noted the Number, Start and End Address delete userdata and create is again but smaller: <br />
```
# NOTE: Some devices use f2fs filesystem for userdata, ext4 won't suit them!
# If you have a problem with the number of partitions
# (can’t create another partition), you can try:
# NOTE: If your device has memory type eMMC, instead of sda use mmcblk0!
sgdisk --resize-table 99 /dev/block/sda # 99 number of maximum allowed partitions
# Deleting userdata will wipe all your data in Android!
(parted) rm <Number>
(parted) mkpart userdata ext4 <Start> <End / 2>
```
After shrinking userdata We can move on to creating the other Partitions:
```
(parted) mkpart esp fat32 <End / 2> <End / 2 + 512MB>
(parted) mkpart arch ext4 <End / 2 + 512MB> <End>
```
Now we set esp to active by running: `set <Number> esp on`. <br />
Once that is done we exit parted and reboot again to recovery:
```
(parted) quit
reboot recovery
```
After that format the partitions:
```
mke2fs -t ext4 /dev/block/by-name/userdata        # Userdata
mkfs.fat -F32 -s1 /dev/block/by-name/esp          # ESP
mkfs.ext4 -f /dev/block/by-name/arch              # Arch root
```
If formating userdata gives a error reboot to recovery and format userdata in the Custom Recovery GUI. <br />

***⚠️ End of the Dangerous Section! ⚠️***

### Mounting UFS

> TODO: How to mount UFS in linux

## Partition USB

Use your favorite way to partition the usb drive according to this sheme:

| Mount point   | Partition     | Partition Type| Suggested size    |
| ------------- | ------------- | ------------- | -------------     |
| mnt/boot      | Esp Part      | fat32         | 1 GiB             |
| mnt           | Arch Root     | ext4          | Rest of the device|

### Mounting USB

Create a temp folder somwhere on your pc and open a terminal.

You can also copy the `ArchLinuxARM-aarch64-latest.tar.gz` you got ealier as you are gonna need it later

Mount the usb according to the mount points above:

Like this:
```
~/uefi » mkdir tmp
~/uefi » sudo mount /dev/sdx2 tmp/
~/uefi » mkdir tmp/boot
~/uefi » sudo mount /dev/sdx1 tmp/boot/
```

## Installing System (Step 3)
Unpack the rootfs onto the mounted device
(NOTE: You **NEED** to be logged in as root, sudo won't work)

```
~/uefi » su root
[root@wisnia uefi]# bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz -C tmp/
```

## Installing and configuring Refind (Step 4)
Okay so now you have a system, now you need a bootloader I'm gonna use refind but you could use something like GRUB2 if you wish.

Unpack `refind-bin-x.xx.x.x.zip` into your temp directory.

Copy over this files/folders from `/refind/` folder into the `tmp/boot/EFI/boot/` folder (if it dosen't exist create it)
```
drivers_aa64/
icons/
tools_aa64/
refind_aa64.efi
```

rename `refind_aa64.efi` to `bootaa64.efi`

Go back into the `tmp/` folder
Rename theese `Image.gz` to `vmlinuz-linux.gz`

Create `refind_linux.conf` file and add this line:

```
"Boot with UUID"   "rw root=UUID=<Arch Linux Root Part UUID>"
```

You can get the UUID by using the blkid command:
```
~/uefi » sudo blkid /dev/sdc2
/dev/sdc2: UUID="cbcc0246-582a-4edf-933b-8a85011b7646" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="5f351c6d-8f34-4d6f-b958-f00646d5e640"
```

In this case UUID would be `cbcc0246-582a-4edf-933b-8a85011b7646`

## Things to do post installation

### Connect to the internet

1. Connect usb internet source (USB tethering or USB to ethernet card)
2. Run `dhcpd &` after logging in to get ip address
3. Check internet access by `ping 1.1.1.1`

### Install Desktop Enviroment

> TODO: figure out how to force Xorg to use framebuffer provided by UEFI