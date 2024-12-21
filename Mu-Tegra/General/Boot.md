# Booting UEFI on your Device

## Description

This Guide will show you how to boot UEFI on your Device.

<table>
<tr><th>Table of Contents</th></th>
<tr><td>

- Booting UEFI
    - [Requirements](#requirements)
    - [Getting UEFI](#getting-uefi)
    - [UEFI Chainload](#uefi-chainload)

</td></tr> </table>

## Requirements
   - USB Drive
   - Golden Keys (If your Device has Disabled Secure Boot don't use this)
   - [UEFI Image](https://github.com/Robotix22/Mu-Tegra)

## Getting UEFI

Let's begin with getting the UEFI Boot Image. <br />
Compile a UEFI Image, follow [this](https://github.com/Robotix22/Mu-Tegra/blob/main/Building.md) Guide to compile a UEFI Image.

## UEFI Chainload

Once you compiled UEFI you get two output Files: `Mu-<Device Codename>.elf` and `UEFILoader.efi`. <br />
If your Device has Disabled Secure Boot Place `UEFILoader.efi` in `\EFI\BOOT\` as `BOOTARM.EFI`. <br />
Otherwise, if Your Device does have Secure Boot Place Golden Keys on the USB Drive and name `UEFILoader.efi` to `boot.efi` on Root. <br />
Once that is Done Place the Output ELF File as `UEFI.elf` on the Root of your USB Drive. <br />
After that, Plug the USB Drive into the Tegra Device and boot from USB, UEFI should start after that.
