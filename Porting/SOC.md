# Adding SOCs

## Description

This Guide will show you how to make an UEFI Port for an Snapdragon SOC

## WARNING

**This is still underconstruction!**

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Adding SOCs
    - [Creating config](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/SOC.md#creating-the-config-file-step-1)
    - [Copying Files & Modify](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/SOC.md#copying-files--modify-them-step-2)
        - [SOC Folder](creating-soc-folder-step-21)
        - [Core Files](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/SOC.md#modify-dsc--fdf--dec-file-step-22)
            - [.dec File](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/SOC.md#modify-dec-file-step-221)
            - [.dsc File](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/SOC.md#modify-dsc-file-step-222)
            - [.fdf File](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/SOC.md#modify-fdf-file-step-223)
        - [Modify SMBios](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/SOC.md#modify-smbios-step-23)
        - [Modify Librarys](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/SOC.md#modify-librarys-step-24)
        - [Modify Boot Logo](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/SOC.md#modify-boot-logo-step-25)
        - [Modify Build Script](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/SOC.md#modify-boot-logo-step-25)

</td></tr> </table>

## Creating the Config File (Step 1)

You may noticed that every SOC has an config File in `./configs` <br />
It contains the `UEFI FD` Size Values <br />
Create a Config File in `./config` called: `<SOC>.conf` with this content:
```
FD_BASE=<Value>
FD_SIZE=<Value>
```
If the SOC needs any "special" Configs add these there.

## Copying Files & Modify them (Step 2)

Struckture of Files for SOCs:
```
./Platforms/<SOC Codename>Pkg/
├── Drivers
│   └── SmBiosTableDxe
│       ├── SmBiosTableDxe.c
│       └── SmBiosTableDxe.inf
├── Include
│   ├── Configuration
│   │   └── DeviceConfigurationMap.h
│   ├── Protocol
│   │   ├── DDRDetails.h
│   │   ├── EFIASN1X509.h
│   │   ├── EFIChargerEx.h
│   │   ├── EFIChipInfo.h
│   │   ├── EFIChipInfoTypes.h
│   │   ├── EFIDDRGetConfig.h
│   │   ├── EFIDisplayUtils.h
│   │   ├── EFIEraseBlock.h
│   │   ├── EFIKernelInterface.h
│   │   ├── EFILimits.h
│   │   ├── EFIMdtp.h
│   │   ├── EFINandPartiGuid.h
│   │   ├── EFIPlatformInfo.h
│   │   ├── EFIPlatformInfoTypes.h
│   │   ├── EFIPmicPon.h
│   │   ├── EFIPmicVersion.h
│   │   ├── EFIQseecom.h
│   │   ├── EFIRamPartition.h
│   │   ├── EFIResetReason.h
│   │   ├── EFIRng.h
│   │   ├── EFIScm.h
│   │   ├── EFIScmModeSwitch.h
│   │   ├── EFISecRSA.h
│   │   ├── EFISmem.h
│   │   ├── EFIUbiFlasher.h
│   │   ├── EFIUsbDevice.h
│   │   ├── EFIUsbEx.h
│   │   ├── EFIUsbfnIo.h
│   │   ├── EFIVerifiedBoot.h
│   │   ├── scm_sip_interface.h
│   │   ├── Source.txt
│   │   └── UsbEx.h
│   └── Resources
│       └── BootLogo.bmp
├── Library
│   ├── AcpiPlatformUpdateLib
│   │   ├── AcpiPlatformUpdateLib.c
│   │   └── AcpiPlatformUpdateLib.inf
│   ├── MsPlatformDevicesLib
│   │   ├── MsPlatformDevicesLib.c
│   │   └── MsPlatformDevicesLib.inf
│   ├── PlatformPrePiLib
│   │   ├── PlatformPrePiLib.inf
│   │   ├── PlatformUtils.c
│   │   └── PlatformUtils.h
│   ├── PowerServicesLib
│   │   ├── PowerServicesLib.c
│   │   └── PowerServicesLib.inf
│   └── RFSProtectionLib
│       ├── RFSProtectionLib.c
│       └── RFSProtectionLib.inf
├── PlatformBuild.py
├── PlatformPei
│   ├── PlatformPeiLib.c
│   ├── PlatformPeiLib.inf
│   └── PlatformPeiLibInternal.h
├── <SOC Codename>.dec
├── <SOC Codename>.dsc
└── <SOC Codename>.fdf
```

## Creating SOC Folder (Step 2.1)

In `./Platforms` are all SOC Folders located. <br />
Copy any SOC Folder of your chosse and rename it to `<SOC Codename>Pkg`.

## Modify .dsc & .fdf & .dec File (Step 2.2)

Now we modify the `.dsc` & `.fdf` & `.dec` File. <br />

## Modify .dec File (Step 2.2.1)

Lets Modify the `.dec` File. <br />
Rename the File to your SOC Codename. <br />
After that open the File and rename the old SOC Name to your SOC Name. <br />
Now we add the SOC Protocols. <br />
Go to: https://git.codelinaro.org/clo/la/abl/tianocore/edk2/ and find your SOC.

![Preview](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/DEC1.png)

Once you found your SOC go to `QcomModulePkg/QcomModulePkg.dec`. <br />
After that copy all Protocols and Guids, replace the old ones in the `.dec` File. <br />

![Preview](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/DEC2.png)
![Preview](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/DEC3.png)

And We need to download the Protocols from `QcomModulePkg/Include/Protocol` and move them into`./Platforms/<SOC Codename>Pkg/Include/Protocol` Override if asked. <br />

![Preview](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/DEC4.png)

Now we now need to change SOC SMBios definition from this:
```
gSM8350TokenSpaceGuid.PcdSmbiosProcessorModel|"Snapdragon (TM) 888 @ 2.84 GHz"|VOID*|0x0000a301
gSM8350TokenSpaceGuid.PcdSmbiosProcessorRetailModel|"SM8350"|VOID*|0x0000a302
```
to this:
```
g<SOC Codename>TokenSpaceGuid.PcdSmbiosProcessorModel|"Snapdragon (TM) <SOC Name> @ <SOC Speed> GHz"|VOID*|0x0000a301
g<SOC Codename>TokenSpaceGuid.PcdSmbiosProcessorRetailModel|"<SOC Codename>"|VOID*|0x0000a302
```

## Modify .dsc File (Step 2.2.2)

In this File we need to change a lot. <br />
Lets begin with renaming the old SOC Name to your SOC Name. <br />
After that we change `PcdArmArchTimerSecIntrNum` and `PcdArmArchTimerIntrNum` to thr right Value. <br />
If the SOC is older than SM8350 use `17` and `18` if not use `29` and `30`. <br />

`PcdGicDistributorBase` and `PcdGicRedistributorsBase` mostly don't need to be changed only on some SOCs. <br />
Set `PcdAcpiDefaultOemRevision` to your SOC Name Example: `SM8350 -> 0x00008350`

Now we need to set `PcdCoreCount` and `PcdClusterCount` to the right Value, You can findout these Values by looking at the specs of the SOC.

## Modify .fdf File (Step 2.2.3)

Here you only need to change the SOC Name to your SOC Name.

## Modify SmBios (Step 2.3)

**NOTE: Add Content**

## Modify Librarys (Step 2.4)

Now we need to modify the Librarys, these are placed under `./Platforms/<SOC Codename>Pkg/Library/`. <br />
In every Librarys `.inf` File rename the SOC Name to yours it should be enough for now.

## Modify Boot Logo (Step 2.5)

Every SOC has its own Boot Logo to show on what SOC the Device is running on. <br />
In `./Platforms/<SOC Codename>Pkg/Include/Resources` modify `BootLogo.bmp` to your SOC Logo.

## Modify Build Script (Step 2.6)

In `PlatformBuild.py` rename the old SOC Name to your SOC Name.
