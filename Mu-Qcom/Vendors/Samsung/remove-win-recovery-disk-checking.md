# Removing Windows recovery and disk checking

## Description

Windows recovery and disk checking on startup can destroy your UFS partition table on Samsung devices. <br />
Unfortunately, even if you disable these options with BCD policies, in some cases Windows will ignore your BCD setting and still boot to recovery or start disk checking. <br />

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Removing Windows recovery and disk checking
   - [What's needed](#things-you-need)
   - [Enable mass storage](#enable-mass-storage-mode-step-1)
   - [Remove Windows recovery](#remove-windows-recovery-step-2)
   - [Remove autochk executable](#remove-autochk-executable-step-3)
   - [Change executable permissions for deletion](#change-executable-permissions-for-deletion-step-31)
   - [Delete autochk.exe](#delete-autochkexe-step-32)

</td></tr> </table>

## Things you need:
   - PC / Laptop with Windows 10 or newer
   - Custom Recovery like TWRP
   - Unlocked Bootloader
   - msc.sh script for your Device

## Enable mass storage mode (Step 1)

To remove these Windows features, you need to put your device in [mass storage mode](../../README.md#device-guides). <br />
If you haven't already, follow Mass Storage Guide for your Device and enable it.<br />

## Remove Windows recovery (Step 2)

After you enabled mass storage mode and connected your device to a Windows computer, <br />
In File Explorer delete this file: <br />
```
# Replace W with your device Win partition letter
W:\Windows\System32\Recovery\WinRE.wim
```

<br />
If your Windows installation has booted before, delete this directory: <br />

```
# Replace W with your device Win partition letter
W:\Recovery
```

## Remove autochk executable (Step 3)

Now we need to remove autochk.exe executable so that Windows wouldn't be able to perform disk checking/fixing procedure on startup. <br />

## Change executable permissions for deletion (Step 3.1)
By default, Windows won't let you delete protected files. <br />
To change that, we need to add our PC username to the file permissions group. <br />
<br />
(Replace W with your device Win partition letter): <br />
In ```W:\Windows\System32``` directory find ```autochk.exe``` and right click on it. <br />
Click on Properties > Security > Advanced > Owner change > (Enter your PC username). <br />
Click Add > Select a principal > (Enter your username) > Check "Full control" under basic permissions. <br />

## Delete autochk.exe (Step 3.2)

After changing the file permissions, now you can delete:
```
# Replace W with your device Win partition letter
W:\Windows\System32\autochk.exe
```
<br />

After doing these steps, you won't have to worry about Windows messing with your UFS partition table on Samsung devices.
