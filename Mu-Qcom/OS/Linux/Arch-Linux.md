# Arch Linux ARM

Make sure to check the Status of your Device [here](https://github.com/Robotix22/Mu-Qcom/blob/main/Status.md).

## Description

This Guide will show you how to Arch Linux Arm on your Device.
You can either use build-in UFS storage, SD Card or external USB device.

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Installing Arch Linux
    - [What's needed](#needed-things)
    - [Partition Device](#partition-device-step-1)
        - [Partition UFS](#partition-ufs)
        - [Partition USB](#partition-usb)
    - [Install](#installing-system-step-2)
    - [Install Bootloader](#installing-and-configuring-refind-step-3)
    - [Things to do post install](#things-to-do-post-installation)

</td></tr> </table>

## Needed Things:
   - PC / Laptop with Linux (VM can be used / WSL to be tested)
   - Unlocked Bootloader
   - [UEFI Image](https://github.com/Robotix22/Mu-Qcom/releases)
   - [Generic Arch Linux Arm image](https://archlinuxarm.org/platforms/armv8/generic)
   - [rEFInd](https://sourceforge.net/projects/refind/files/0.14.0.2/refind-bin-0.14.0.2.zip/download)

## Partition Device (Step 1)

## Partition UFS (Method 1)

> TODO: Add Tested UFS Steps.

### Mounting UFS

> TODO: How to mount UFS in linux.

## Partition USB / SD Card (Method 2)

Use your favorite way to partition the usb drive according to this sheme:

| Mount point   | Partition     | Partition Type| Suggested size    |
| ------------- | ------------- | ------------- | -------------     |
| mnt/boot      | Esp Part      | fat32         | 1 GiB             |
| mnt           | Arch Root     | ext4          | Rest of the device|

Then Create a temp folder somwhere on your pc and open a terminal.

You can also copy the `ArchLinuxARM-aarch64-latest.tar.gz` you got ealier as you are gonna need it later

Mount the External Storage Device according to the mount points above:

Like this:
```
~/uefi » su root
[root@wisnia uefi]# mkdir tmp
[root@wisnia uefi]# mount /dev/sdx2 tmp/
[root@wisnia uefi]# mkdir tmp/boot
[root@wisnia uefi]# mount /dev/sdx1 tmp/boot/
```

## Installing System (Step 2)

Unpack the rootfs onto the mounted device
(NOTE: You **NEED** to be logged in as root, sudo won't work)

```
~/uefi » su root
[root@wisnia uefi]# bsdtar -xpf ArchLinuxARM-aarch64-latest.tar.gz -C tmp/
```

## Installing and configuring Refind (Step 3)

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
~/uefi » sudo blkid /dev/sdx2
/dev/sdx2: UUID="cbcc0246-582a-4edf-933b-8a85011b7646" BLOCK_SIZE="4096" TYPE="ext4" PARTUUID="5f351c6d-8f34-4d6f-b958-f00646d5e640"
```

In this case UUID would be `cbcc0246-582a-4edf-933b-8a85011b7646`

After that unmount device:

```
[root@wisnia tmp]# umount tmp/boot
[root@wisnia tmp]# umount tmp/
[root@wisnia tmp]# sync
```

## Things to do post installation

### Connect to the internet

1. Connect usb internet source (USB tethering or USB to ethernet card)
2. Run `dhcpcd &` after logging in to get ip address
3. Check internet access by `ping 1.1.1.1`

### Initialize the pacman keyring and populate the Arch Linux ARM package signing keys

```
pacman-key --init
pacman-key --populate archlinuxarm
```
After doing this you can now use pacman to install packages

### Install Desktop Enviroment

> TODO: figure out how to force Xorg to use framebuffer provided by UEFI
