# Adding Devices

If you have any issues ask on our [Discord](https://discord.gg/Dx2QgMx7Sv).

## Description

This Guide will show you how to create an minimal UEFI Port for your Device. <br />

## WARNING

**Booting Windows/Linux on Sony/Google Device will wipe your UFS Clean! (Unable to recover)**

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Adding Devices
    - [Requirements](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#device-recuirements)
    - [Copying Files](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#copying-files-step-1)
    - [Creating Config](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#creating-the-config-file-step-2)
    - [Creating Files](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#creating-files-step-3)
         - [Creating .dsc & .dec & .fdf File](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#creating-dsc--dec--fdf-file-step-31)
              - [Creating .dsc](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#creating-dsc-file-step-311)
              - [Creating .dec](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#creating-dec-file-step-312)
              - [Creating .fdf](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#creating-fdf-file-step-313)
         - [Creating fdf.inc Files](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#creating-fdfinc-files-step-32)
              - [Creating ACPI.inc](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#creating-acpiinc-step-321)
              - [Creating APRIORI.inc](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#creating-aprioriinc-step-322)
              - [Creating DXE.inc](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#creating-dxeinc-step-323)
              - [Creating RAW.inc](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#creating-rawinc-step-324)
              - [Creating FDT.inc](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#creating-fdtinc-step-325)
         - [Creating MemoryMap](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#creating-platformmemorymap-library-step-33)
    - [Building](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#building)
    - [Troubleshooting](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#troubleshooting)
         - [DxeCore](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#dxecore)
         - [Crash](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#device-rebootsgets-stuck-on-something)
         - [Synchronous Exception](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Device.md#synchronous-exception)

</td></tr> </table>

## Device Requirements

To Port UEFI to your Phone, it needs the following things:

- an Snapdragon SoC
- XBL or UEFI in `/dev/block/by-name/`
- fdt in `/sys/firmware/`

## Copying Files (Step 1)

Lets begin with Copying Files. <br />
Copy the fdt File from `/sys/firmware/` and Place it as `<Device Codename.dtb>` under `./ImageResources/DTBs/`. <br />
Extract your xbl from `/dev/block/by-name/` and Place it somewhere you can reach it. <br />
After Copying the xbl File or the uefi File extract all UEFI Binaries from it with [UEFIReader](https://github.com/WOA-Project/UEFIReader). <br />
Now Move all the output Files from UEFI Reader in `./Binaries/<Device Codename>/`.

## Creating the Config File (Step 2)

Every Device has its own config file to define some device specific things like: SoC. <br />
Create a File called `<Device Codename>.conf` in `./configs/`. <br />
It should contain at least this:
```
# General Config
TARGET_DEVICE_VENDOR="<Device Vendor>"

# UEFI FD Config
TARGET_FD_BASE="<FD Base>"
TARGET_FD_SIZE="<FD Size>"
TARGET_FD_BLOCKS="<FD Blocks>"
```
If your Device has Models with diffrent RAM Sizes, Add `MULTIPLE_RAM_SIZE="TRUE"` under General Config. <br />
`<FD Base/Size Value>` is the UEFI FD Value in the MemoryMap (uefiplat.cfg). <br />
`<FD Blocks>` is the Number of Blocks UEFI FD has, [<FD Size> / 0x1000].

## Creating Files (Step 3)

Struckture of the Device Files:
```
./Platforms/<Device Vendor>/<Device Codename>Pkg/
├── Include
│   ├── ACPI.inc
│   ├── APRIORI.inc
│   ├── DXE.inc
│   ├── FDT.inc
│   └── RAW.inc
├── Library
│   └── PlatformMemoryMapLib
│       ├── PlatformMemoryMapLib.c
│       └── PlatformMemoryMapLib.inf
├── PlatformBuild.py
├── <Device Codename>.dec
├── <Device Codename>.dsc
└── <Device Codename>.fdf
```

## Creating .dsc & .dec & .fdf File (Step 3.1)

## Creating .dsc File (Step 3.1.1)

Lets begin with the `.dsc` File <br />
Create a File called `<Device Codename>.dsc` in `./Platforms/<Device Vendor>/<Device Codename>Pkg/`. <br />
Here is an template:
```
## @file
#
#  Copyright (c) 2011-2015, ARM Limited. All rights reserved.
#  Copyright (c) 2014, Linaro Limited. All rights reserved.
#  Copyright (c) 2015 - 2016, Intel Corporation. All rights reserved.
#  Copyright (c) 2018 - 2019, Bingxing Wang. All rights reserved.
#  Copyright (c) 2022, Xilin Wu. All rights reserved.
#
#  SPDX-License-Identifier: BSD-2-Clause-Patent
#
##

################################################################################
#
# Defines Section - statements that will be processed to create a Makefile.
#
################################################################################
[Defines]
  PLATFORM_NAME                  = <Device Codename>
  PLATFORM_GUID                  = <GUID>
  PLATFORM_VERSION               = 0.1
  DSC_SPECIFICATION              = 0x00010005
  OUTPUT_DIRECTORY               = Build/<Device Codename>Pkg
  SUPPORTED_ARCHITECTURES        = AARCH64
  BUILD_TARGETS                  = DEBUG|RELEASE
  SKUID_IDENTIFIER               = DEFAULT
  FLASH_DEFINITION               = <Device Codename>Pkg/<Device Codename>.fdf
  USE_DISPLAYDXE                 = 0
  # Set this to 1 If your Device is A/B Device
  AB_SLOT_SUPPORT                = 0
  USE_UART                       = 0

  # If your SoC has multimple variants define the Number here
  # If not don't add this Define
  SOC_TYPE                       = 2

# If your SoC has multimple variants define the Number here
# If not don't add this Build Option
[BuildOptions.common]
  *_*_*_CC_FLAGS = -DSOC_TYPE=$(SOC_TYPE)

[LibraryClasses.common]
  PlatformMemoryMapLib|<Device Codename>Pkg/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.inf

[PcdsFixedAtBuild.common]
  gArmTokenSpaceGuid.PcdSystemMemoryBase|<Start Address>    # Starting address
  gArmTokenSpaceGuid.PcdSystemMemorySize|<RAM Size>         # 8GB Size

  gEfiMdeModulePkgTokenSpaceGuid.PcdFirmwareVendor|L"<Your Github Name>"

  gArmTokenSpaceGuid.PcdCpuVectorBaseAddress|<CPU Vector Base Address>

  gEmbeddedTokenSpaceGuid.PcdPrePiStackBase|<UEFI Stack Base Address>
  gEmbeddedTokenSpaceGuid.PcdPrePiStackSize|<UEFI Stack Size>

  # SmBios
  gQcomPkgTokenSpaceGuid.PcdSmbiosSystemVendor|"<Device Vendor>"
  gQcomPkgTokenSpaceGuid.PcdSmbiosSystemModel|"<Device Model>"
  gQcomPkgTokenSpaceGuid.PcdSmbiosSystemRetailModel|"<Device Codename>"
  gQcomPkgTokenSpaceGuid.PcdSmbiosSystemRetailSku|"<Device_Model>_<Device_Codename>"
  gQcomPkgTokenSpaceGuid.PcdSmbiosBoardModel|"<Device Model>"

  # Simple FrameBuffer
  gQcomPkgTokenSpaceGuid.PcdMipiFrameBufferWidth|<Display Width>
  gQcomPkgTokenSpaceGuid.PcdMipiFrameBufferHeight|<Display Height>
  gQcomPkgTokenSpaceGuid.PcdMipiFrameBufferPixelBpp|<Display Bpp>

[PcdsDynamicDefault.common]
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoHorizontalResolution|<Display Width>
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoVerticalResolution|<Display Height>
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoHorizontalResolution|<Display Width>
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoVerticalResolution|<Display Height>
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupConOutColumn|<Setup Con Column>
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupConOutRow|<Setup Con Row>
  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutColumn|<Con Column>
  gEfiMdeModulePkgTokenSpaceGuid.PcdConOutRow|<Con Row>

!include <SoC Codename>Pkg/<SoC Codenmae>.dsc.inc
```

`<GUID>` is a Value to identify your Device, Generate one [here](https://guidgenerator.com/)
`<Start Address>` is the Start Address of the MemoryMap (uefiplat.cfg). <br />
`<RAM Size>` is the RAM size of your Device, [(RAM Size in hex) * 0x100000]. <br />
`<CPU Vector Base Address>` is the Base Address of `CPU Vectors` in the MemoryMap (uefiplat.cfg). <br />
`<UEFI Stack base/Size>` is the Base/Size Address of `UEFI Stack` in the MemoryMap (uefiplat.cfg). <br />
`<UART Base Address>` is the First Hex Address of the serial0 Node in your dts. <br />
`<Device Bpp>` is the Value of your Display bits per pixel, [(Display Width) * (Display Height) / 8 or 6 or 4] Valid Resoults are: 32, 24 and 16. <br />
`<Setup Con Column> / <Con Column>` is the Value of [(Display Width) / 8]. <br />
`<Setup Con Row> / <Con Row>` is the Value of [(Display Height) / 19].

## Creating .dec File (Step 3.1.2)

After we created the .dsc File we will now continue now with the .dec File. <br />
Create a File called `<Device Codename>.dec` in `./Platforms/<Device Vendor>/<Device Codename>/`. <br />
Here is an template what it should contain:
```
[Defines]
  DEC_SPECIFICATION                   = 0x00010005
  PACKAGE_NAME                        = <Device Codename>
  PACKAGE_GUID                        = <GUID>
  PACKAGE_VERSION                     = 0.1

[Includes.common]
  Include                               # Root include for the package

[Guids.common]
  # NOTE: For these Values you need to use the GUID you generated earlier!
  # These are just example Values.
  g<Device Codename>TokenSpaceGuid    = { 0x1ead32ce, 0x3165, 0x49eb, { 0xa9, 0x2d, 0xe8, 0x8a, 0x42, 0x57, 0x20, 0x02 } }
```

`<GUID>` is the same GUID as in .dsc File.

## Creating .fdf File (Step 3.1.3)

Once the .dec File is complete we can move on to the .fdf File. <br />
Create File called `<Device Codename>.fdf` in `./Platforms/<Device Vendor>/<Device Codename>/`. <br />
The .fdf File contains Specific Stuff about your Device, Here is an template how it should look:
```
## @file
#
#  Copyright (c) 2018, Linaro Limited. All rights reserved.
#
#  SPDX-License-Identifier: BSD-2-Clause-Patent
#
##

################################################################################
#
# FD Section
# The [FD] Section is made up of the definition statements and a
# description of what goes into  the Flash Device Image.  Each FD section
# defines one flash "device" image.  A flash device image may be one of
# the following: Removable media bootable image (like a boot floppy
# image,) an Option ROM image (that would be "flashed" into an add-in
# card,) a System "Flash"  image (that would be burned into a system's
# flash) or an Update ("Capsule") image that will be used to update and
# existing system flash.
#
################################################################################

[FD.<Device Codename>_UEFI]
BaseAddress   = $(FD_BASE)|gArmTokenSpaceGuid.PcdFdBaseAddress # The base address of the FLASH Device.
Size          = $(FD_SIZE)|gArmTokenSpaceGuid.PcdFdSize        # The size in bytes of the FLASH Device
ErasePolarity = 1

# This one is tricky, it must be: BlockSize * NumBlocks = Size
BlockSize     = 0x1000
NumBlocks     = $(FD_BLOCKS)

################################################################################
#
# Following are lists of FD Region layout which correspond to the locations of different
# images within the flash device.
#
# Regions must be defined in ascending order and may not overlap.
#
# A Layout Region start with a eight digit hex offset (leading "0x" required) followed by
# the pipe "|" character, followed by the size of the region, also in hex with the leading
# "0x" characters. Like:
# Offset|Size
# PcdOffsetCName|PcdSizeCName
# RegionType <FV, DATA, or FILE>
#
################################################################################

0x00000000|$(FD_SIZE)
gArmTokenSpaceGuid.PcdFvBaseAddress|gArmTokenSpaceGuid.PcdFvSize
FV = FVMAIN_COMPACT

################################################################################
#
# FV Section
#
# [FV] section is used to define what components or modules are placed within a flash
# device file.  This section also defines order the components and modules are positioned
# within the image.  The [FV] section consists of define statements, set statements and
# module statements.
#
################################################################################

[FV.FvMain]
FvNameGuid         = 631008B0-B2D1-410A-8B49-2C5C4D8ECC7E
BlockSize          = 0x1000
NumBlocks          = 0        # This FV gets compressed so make it just big enough
FvAlignment        = 8        # FV alignment and FV attributes setting.
ERASE_POLARITY     = 1
MEMORY_MAPPED      = TRUE
STICKY_WRITE       = TRUE
LOCK_CAP           = TRUE
LOCK_STATUS        = TRUE
WRITE_DISABLED_CAP = TRUE
WRITE_ENABLED_CAP  = TRUE
WRITE_STATUS       = TRUE
WRITE_LOCK_CAP     = TRUE
WRITE_LOCK_STATUS  = TRUE
READ_DISABLED_CAP  = TRUE
READ_ENABLED_CAP   = TRUE
READ_STATUS        = TRUE
READ_LOCK_CAP      = TRUE
READ_LOCK_STATUS   = TRUE

  !include Include/APRIORI.inc
  !include Include/DXE.inc
  !include Include/RAW.inc

  # Secure Boot Key Enroll
  INF SecurityPkg/VariableAuthenticated/SecureBootConfigDxe/SecureBootConfigDxe.inf
  #INF QcomPkg/Drivers/SecureBootProvisioningDxe/SecureBootProvisioningDxe.inf

  INF EmbeddedPkg/Drivers/VirtualKeyboardDxe/VirtualKeyboardDxe.inf

  # BDS
  INF MdeModulePkg/Universal/SmbiosDxe/SmbiosDxe.inf
  INF MdeModulePkg/Universal/SetupBrowserDxe/SetupBrowserDxe.inf
  INF MdeModulePkg/Universal/DriverHealthManagerDxe/DriverHealthManagerDxe.inf

  # HID Support
  INF HidPkg/HidKeyboardDxe/HidKeyboardDxe.inf
  INF HidPkg/HidMouseAbsolutePointerDxe/HidMouseAbsolutePointerDxe.inf

  # ACPI and SMBIOS
  INF MdeModulePkg/Universal/Acpi/AcpiTableDxe/AcpiTableDxe.inf
  INF MdeModulePkg/Universal/Acpi/AcpiPlatformDxe/AcpiPlatformDxe.inf
  INF <SoC Codename>Pkg/Drivers/SmBiosTableDxe/SmBiosTableDxe.inf

  # ACPI Tables
  !include Include/ACPI.inc

  # DT
  INF EmbeddedPkg/Drivers/DtPlatformDxe/DtPlatformDxe.inf
  !include Include/FDT.inc

  INF MdeModulePkg/Universal/EsrtFmpDxe/EsrtFmpDxe.inf

  !include QcomPkg/Frontpage.fdf.inc

  INF DfciPkg/IdentityAndAuthManager/IdentityAndAuthManagerDxe.inf

  FILE FREEFORM = PCD(gOemPkgTokenSpaceGuid.PcdLogoFile) {
    SECTION RAW = <Device Codename>Pkg/Resources/BootLogo.bmp      # The Splash Screen of your Device
    SECTION UI = "Logo"
  }

  # TODO: Make this Image for every single Device
  FILE FREEFORM = PCD(gMsCorePkgTokenSpaceGuid.PcdRegulatoryGraphicFileGuid) {
    SECTION RAW = QcomPkg/Include/Resources/RegulatoryLogos.png
  }

  INF QcomPkg/Drivers/GpioButtons/GpioButtons.inf
  INF QcomPkg/Drivers/KernelErrataPatcher/KernelErrataPatcher.inf

  # NOTE: Only add these two entries if your Device is an A/B Device.
  # If unsure leave them out of the File.
  INF GPLDrivers/Drivers/BootSlotDxe/BootSlotDxe.inf
  INF GPLDrivers/Applications/SwitchSlotsApp/SwitchSlotsApp.inf

[FV.FVMAIN_COMPACT]
FvAlignment        = 8
ERASE_POLARITY     = 1
MEMORY_MAPPED      = TRUE
STICKY_WRITE       = TRUE
LOCK_CAP           = TRUE
LOCK_STATUS        = TRUE
WRITE_DISABLED_CAP = TRUE
WRITE_ENABLED_CAP  = TRUE
WRITE_STATUS       = TRUE
WRITE_LOCK_CAP     = TRUE
WRITE_LOCK_STATUS  = TRUE
READ_DISABLED_CAP  = TRUE
READ_ENABLED_CAP   = TRUE
READ_STATUS        = TRUE
READ_LOCK_CAP      = TRUE
READ_LOCK_STATUS   = TRUE

  INF QcomPkg/PrePi/PeiUniCore.inf

  FILE FREEFORM = dde58710-41cd-4306-dbfb-3fa90bb1d2dd {
    SECTION UI = "uefiplat.cfg"
    SECTION RAW = Binaries/<Device Codename>/RawFiles/uefiplat.cfg
  }

  FILE FV_IMAGE = 9E21FD93-9C72-4c15-8C4B-E77F1DB2D792 {
    SECTION GUIDED EE4E5898-3914-4259-9D6E-DC7BD79403CF PROCESSING_REQUIRED = TRUE {
      SECTION FV_IMAGE = FVMAIN
    }
  }

  !include QcomPkg/CommonFdf.fdf.inc
```

## Creating .fdf.inc Files (Step 3.2)

Now we create some files for the `.fdf` File

## Creating ACPI.inc (Step 3.2.1)

Lets begin with `ACPI.inc`, Create `ACPI.inc` in `./Platforms/<Device Vendor>/<Device Codename>Pkg/Include/`. <br />
After Creating the File you can add ACPI Tables **If your SoC has already ACPI Tables in the Folder!** otherwise leave it empty. <br />
If there are ACPI Tables add this to your `ACPI.inc`:
```
FILE FREEFORM = 7E374E25-8E01-4FEE-87F2-390C23C606CD {
# SECTION RAW = <SoC Codename>Pkg/AcpiTables/APIC.aml
  SECTION RAW = <SoC Codename>Pkg/AcpiTables/APIC.UniCore.aml
# SECTION RAW = <SoC Codename>Pkg/AcpiTables/BERT.aml
# SECTION RAW = <SoC Codename>Pkg/AcpiTables/BGRT.aml
# SECTION RAW = <SoC Codename>Pkg/AcpiTables/CSRT.aml
# SECTION RAW = <SoC Codename>Pkg/AcpiTables/DBG2.aml
  SECTION RAW = <SoC Codename>Pkg/AcpiTables/DSDT_minimal.aml
  SECTION RAW = <SoC Codename>Pkg/AcpiTables/FACP.aml
# SECTION RAW = <SoC Codename>Pkg/AcpiTables/FPDT.aml
  SECTION RAW = <SoC Codename>Pkg/AcpiTables/GTDT.aml
# SECTION RAW = <SoC Codename>Pkg/AcpiTables/IORT.aml
# SECTION RAW = <SoC Codename>Pkg/AcpiTables/MCFG.aml
# SECTION RAW = <SoC Codename>Pkg/AcpiTables/MSDM.aml
# SECTION RAW = <SoC Codename>Pkg/AcpiTables/PPTT.aml
# SECTION RAW = <SoC Codename>Pkg/AcpiTables/SPCR.aml
# SECTION RAW = <SoC Codename>Pkg/AcpiTables/TPM2.aml
# SECTION RAW = <SoC Codename>Pkg/AcpiTables/XSDT.aml
  SECTION RAW = QcomPkg/AcpiTables/common/SSDT.aml
  SECTION RAW = QcomPkg/AcpiTables/common/TPMDev.aml
  SECTION RAW = QcomPkg/AcpiTables/common/SoftwareTpm2Table.aml
  SECTION UI = "AcpiTables" 
}
```

## Creating APRIORI.inc (Step 3.2.2)

Now we continue with `APRIORI.inc`, Create `APRIORI.inc` in `./Platforms/<Device Vendor>/<Device Codename>Pkg/Include/`. <br />
We need the order of the Binaries in `APRIORI.inc`, Use UEFITool to get the Order:

![Preview](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/APRIORI1.png)
![Preview](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/APRIORI2.png)

Next we place all the Binaries in `APRIORI.inc` like this:
```
INF <Path to .inf File>
```
After you ordered and added all the Files you also need to add some extra stuff to `APRIORI.inc`:
```
INF MdeModulePkg/Universal/PCD/Dxe/Pcd.inf
INF ArmPkg/Drivers/ArmPsciMpServicesDxe/ArmPsciMpServicesDxe.inf
INF MdeModulePkg/Bus/Pci/PciBusDxe/PciBusDxe.inf
INF QcomPkg/Drivers/SimpleFbDxe/SimpleFbDxe.inf
```

`Pcd` should be under `DxeMain`. <br />
`ArmPsciMpServicesDxe` should be under `TimerDxe`. <br />
`PciBusDxe` should be over `Fat`. <br />
`SimpleFbDxe` should replace `DisplayDxe` if DisplayDxe dosen't work already.

Your APRIORI.inc should **NOT** Have SecurityStub in it, If so remove it or UEFI will get Stuck on that one.

## Creating DXE.inc File (Step 3.2.3)

After that we can now move on to `DXE.inc`, Create `DXE.inc` in `./Platforms/<Device Vendor>/<Device Codename>Pkg/Include/`. <br />
Now again we need the Order, To get the order of `DXE.inc` Open xbl or uefi in UEFITool and you will already see the order. <br />
Again we place all the Binaries like this:
```
INF <Path to .inf>
```
Also here again you need to add some extra Stuff:
```
INF ArmPkg/Drivers/ArmPsciMpServicesDxe/ArmPsciMpServicesDxe.inf
INF MdeModulePkg/Universal/Acpi/BootGraphicsResourceTableDxe/BootGraphicsResourceTableDxe.inf
INF MdeModulePkg/Universal/Acpi/FirmwarePerformanceDataTableDxe/FirmwarePerformanceDxe.inf
INF MdeModulePkg/Universal/PCD/Dxe/Pcd.inf
INF QcomPkg/Drivers/SimpleFbDxe/SimpleFbDxe.inf
INF MdeModulePkg/Bus/Usb/UsbMouseAbsolutePointerDxe/UsbMouseAbsolutePointerDxe.inf
```

`ArmPsciMpServicesDxe` should be under `TimerDxe`. <br />
`BootGraphicsResourceTableDxe` should be under `BdsDxe`. <br />
`FirmwarePerformanceDxe` should be under `BootGraphicsResourceTableDxe`. <br />
`Pcd` should be under `FirmwarePerformanceDxe`. <br />
`SimpleFbDxe` should replace `DisplayDxe` if DisplayDxe dosen't work already. <br />
`UsbMouseAbsolutePointerDxe` should be under `UsbKbDxe`. <br />

## Creating RAW.inc (Step 3.2.4)

Now lets move on to `RAW.inc`. <br />
Add all RAW Files that UEFI Tool displays and add them like this:
```
FILE FREEFORM = <GUID> {
  SECTION RAW = Binaries/<Device Codename>/RawFiles/<File Name>.<File Extension>
  SECTION UI = "<Name>"
}
```

## Creating FDT.inc (Step 3.2.5)

After Creating RAW.inc we now add FDT.inc. <br />
Your FDT.inc should contain this:
```
# Mainline DTB
#FILE FREEFORM = 25462CDA-221F-47DF-AC1D-259CFAA4E326 {
#  SECTION RAW = <Device Codename>Pkg/FdtBlob/<SoC Codename>-<Device Model>.dtb
#  SECTION UI = "DeviceTreeBlob"
#}
```
If you have an mainline DTB for your Device add it to `./Platforms/<Device Vendor>/<Device Codename>Pkg/FdtBlob/`. <br />
then uncomment the Mainline DTB part. <br />

## Creating PlatformMemoryMap Library (Step 3.3)

Lets move on making Memory Map. <br />
We will use uefiplat.cfg to create the Memory Map. <br />
Create a Folder Named `PlatformMemoryMapLib` in `./Platforms/<Device Vendor>/<Device Codename>Pkg/Library/`. <br />
After that create two Files called `PlatformMemoryMapLib.c` and `PlatformMemoryMapLib.inf`. <br />
Here is an template for the .c File:
```
#include <Library/BaseLib.h>
#include <Library/PlatformMemoryMapLib.h>

static ARM_MEMORY_REGION_DESCRIPTOR_EX gDeviceMemoryDescriptorEx[] = {
    /* Name               Address     Length      HobOption        ResourceAttribute    ArmAttributes
                                                          ResourceType          MemoryType */

    /* DDR Regions */

    /* RAM partition regions */

    /* Other memory regions */

    /* Register regions */

    /* Terminator for MMU */
    {"Terminator", 0, 0, 0, 0, 0, 0, 0}};

ARM_MEMORY_REGION_DESCRIPTOR_EX *GetPlatformMemoryMap()
{
    return gDeviceMemoryDescriptorEx;
}
```

Place all `DDR` Memory Regions under `DDR Regions` in `PlatformMemoryMapLib.c`, Example:
```
0xEA600000, 0x02400000, "Display Reserved",  AddMem, MEM_RES, SYS_MEM_CAP, Reserv, WRITE_THROUGH_XN
```
would become in the Memory Map:
```
{"Display Reserved",  0xEA600000, 0x02400000, AddMem, MEM_RES, SYS_MEM_CAP, Reserv, WRITE_THROUGH_XN},
```
Do that with every Memory Region but if an `#` is infront of an Memory Region do not add it. <br />
After that it should look something like [this](https://github.com/Robotix22/Mu-Qcom/blob/main/Platforms/Xiaomi/viliPkg/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.c).

## Building

Now Build your Device with:
```
./build_uefi.sh -d <Codename> -r DEBUG
```

## Troubleshooting

### DxeCore

You may encounter an issue that `DxeCore` does not load. <br />
There are many Reason that this may Happen. <br />
If you encouter this issue please ask in [Discord](https://discord.gg/Dx2QgMx7Sv).

### Device Reboots/gets Stuck on something

This is an common Issue. <br />
If the Phone gets stuck on something like this:
```
Loading <File Name> at <Value>
```
Then you may need to patch that File but it should be okay to remove it for now. <br />
If The Phone reboots after booting UEFI the Issue is may an Driver again. <br />

### Synchronous Exception

That also may happen if you Port UEFI. <br />

![Preview](https://github.com/Robotix22/UEFI-Guides/blob/main/Mu-Qcom/Porting/Synchronous-Exception.jpg)

One of these Drivers causes the Issue, In that Example it it PILDxe, you can cut it for now.
