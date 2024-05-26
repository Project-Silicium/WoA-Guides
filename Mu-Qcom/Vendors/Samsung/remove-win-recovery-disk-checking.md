# Removing Windows recovery and disk checking

## Description

Windows recovery and disk checking on startup can destroy your UFS partition table on Samsung devices. <br />
Unfortunately even if you disable these options with BCD policies, in some cases Windows will ignore your BCD setting and still boot to recovery or start disk checking. <br />

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Removing Windows recovery and disk checking
   - [What's needed](#things-you-need)
   - [Enable mass storage](#preparing-step-1)
   - [Fix](#fix-ufs-step-2)
     - [Set Online](#setting-ufs-online-step-21)
     - [Restore GPT](#restoring-ufs-step-22)

</td></tr> </table>

## Things you need:
   - PC / Laptop with Windows 10 or newer
   - Custom Recovery like TWRP
   - Unlocked Bootloader
   - msc.sh script for your Device

## Enable mass storage mode (Step 1)

To remove these Windows features, you need to put your device in [mass storage mode](https://github.com/arminask/WoA-Guides/blob/main/Mu-Qcom/README.md#device-guides). <br />
If you haven't already follow the Mass Storage Guide of your Device as its needed here. <br />

## Remove Windows recovery (Step 2)

After you enabled mass storage mode and connected your device to a Windows computer, <br />
with File Explorer remove this file (Replace W with your device Win partition letter): <br />
Delete: W:\Windows\System32\Recovery\WinRE.wim
<br />
If your Windows installation has booted before (Replace W with your device partition Win partition letter): <br />
Delete: W:\Recovery

## Remove autochk executable (Step 3)

Now we need to remove autochk.exe executable so that Windows wouldn't be able to perform disk checking/fixing procedure on startup. <br />

## Change executable permissions for deletion (Step 3.1)
By default, Windows won't let you delete protected files, to change that, we need to add our PC username to the file permissions group. <br />
(Replace W with your device Win partition letter): <br />
In W:\Windows\System32 directory find autochk.exe and right click on it. <br />
Click on Properties > Security > Advanced > Owner change > (Enter your PC username) <br />
Click Add > Select a principal > (Enter your username) > Check "Full control" under basic permissions. <br />
Now close all dialog boxes and delete autochk.exe file
