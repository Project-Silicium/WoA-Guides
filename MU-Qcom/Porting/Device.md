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
    - [Requirements](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#device-recuirements)
    - [Copying Files](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#copying-files-step-1)
    - [Creating Config](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#creating-the-config-file-step-2)
    - [Creating Files](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#creating-files-step-3)
         - [Creating .dsc & .dec & .fdf File](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#creating-dsc--dec--fdf-file-step-31)
              - [Creating .dsc](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#creating-dsc-file-step-311)
              - [Creating .dec](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#creating-dec-file-step-312)
              - [Creating .fdf](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#creating-fdf-file-step-313)
         - [Creating fdf.inc Files](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#creating-fdfinc-files-step-32)
              - [Creating ACPI.inc](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#creating-acpiinc-step-321)
              - [Creating APRIORI.inc](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#creating-aprioriinc-step-322)
              - [Creating DXE.inc](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#creating-dxeinc-step-323)
              - [Creating RAW.inc](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#creating-rawinc-step-324)
              - [Creating FDT.inc](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#creating-fdtinc-step-325)
         - [Creating MemoryMap](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#creating-platformmemorymap-library-step-33)
         - [Creating PlatformPei](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#creating-platformpei-library-step-34)
    - [Building](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#building)
    - [Troubleshooting](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#troubleshooting)
         - [DxeCore](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#dxecore)
         - [Crash](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#device-rebootsgets-stuck-on-something)
         - [Synchronous Exception](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Device.md#synchronous-exception)

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
Now Move all the output Files from UEFI Reader in `./Platforms/Binaries/<Device Codename>/`.

## Creating the Config File (Step 2)

Every Device has its own config file to define some device specific things like: SoC. <br />
Create a File called `<Device Codename>.conf` in `./configs/devices/`. <br />
It should contain at least this:
```
SOC_PLATFORM="<SOC Codename>"
TARGET_DEVICE_VENDOR="<Device Vendor>"
```

## Creating Files (Step 3)

Struckture of the Device Files:
```
./Platforms/<Device Vendor>/<Device Codename>Pkg/
├── Include
│   ├── ACPI.inc
│   ├── APRIORI.inc
│   ├── Configuration
│   │   └── DeviceConfigurationMap.h
│   ├── DXE.inc
│   ├── FDT.inc
│   └── RAW.inc
├── Library
│   ├── PlatformMemoryMapLib
│   │   ├── PlatformMemoryMapLib.c
│   │   └── PlatformMemoryMapLib.inf
│   └── PlatformPei
│       ├── PlatformPeiLib.c
│       ├── PlatformPeiLib.inf
│       └── PlatformPeiLibInternal.h
├── PlatformBuild.py
├── <Device Codename>.dec
├── <Device Codename>.dsc
└── <Device Codename>.fdf
```

## Creating .dsc & .dec & .fdf File (Step 3.1)

## Creating .dsc File (Step 3.1.1)

Lets begin with the `.dsc` File <br />
Create a File called `<Device Codename>.dsc` in `./Platforms/<Device Vendor>/<Device Codename>/`. <br />
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
  AB_SLOT_SUPPORT                = 0
  USE_UART                       = 0

[LibraryClasses.common]
  PlatformMemoryMapLib|<Device Codename>Pkg/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.inf
  PlatformPeiLib|<Device Codename>Pkg/Library/PlatformPei/PlatformPeiLib.inf

[PcdsFixedAtBuild.common]
  gArmTokenSpaceGuid.PcdSystemMemoryBase|<Start Address>    # Starting address
  gArmTokenSpaceGuid.PcdSystemMemorySize|<RAM Size>         # 8GB Size

  gArmTokenSpaceGuid.PcdCpuVectorBaseAddress|<CPU Vector Base Address>

  gEmbeddedTokenSpaceGuid.PcdPrePiStackBase|<UEFI Stack Base Address>
  gEmbeddedTokenSpaceGuid.PcdPrePiStackSize|<UEFI Stack Size>

  # Simple FrameBuffer
  gQcomTokenSpaceGuid.PcdMipiFrameBufferWidth|<Display Width>
  gQcomTokenSpaceGuid.PcdMipiFrameBufferHeight|<Display Height>
  gQcomTokenSpaceGuid.PcdMipiFrameBufferPixelBpp|<Display Bpp>

  # UART
  gQcomTokenSpaceGuid.PcdDebugUartPortBase|<UART Base Address>

  # Device Info
  gQcomTokenSpaceGuid.PcdSmbiosSystemVendor|"<Device Vendor>"
  gQcomTokenSpaceGuid.PcdSmbiosSystemModel|"<Device Model>"
  gQcomTokenSpaceGuid.PcdSmbiosSystemRetailModel|"<Device Codename>"
  gQcomTokenSpaceGuid.PcdSmbiosSystemRetailSku|"<Device_Model>_<Device_Codename>"
  gQcomTokenSpaceGuid.PcdSmbiosBoardModel|"<Device Model>"

[PcdsDynamicDefault.common]
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoHorizontalResolution|<Display Width>
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoVerticalResolution|<Display Height>
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoHorizontalResolution|<Display Width>
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoVerticalResolution|<Display Height>

!include SM8350Pkg/SM8350.dsc.inc
```

`<GUID>` is a Value to identify your Device, Generate one [here](https://guidgenerator.com/)
`<Start Address>` is the Start Address of the MemoryMap (uefiplat.cfg). <br />
`<RAM Size>` is the RAM size of your Device, [<RAM Size in hex> * 0x100000]. <br />
`<CPU Vector Base Address>` is the Base Address of `CPU Vectors` in the MemoryMap (uefiplat.cfg). <br />
`<UEFI Stack base/Size>` is the Base/Size Address of `UEFI Stack` in the MemoryMap (uefiplat.cfg). <br />
`<UART Base Address>` is the First Hex Address of the serial0 Node in your dts. <br />
`<Device Bpp>` is the Value of your Display bits per pixel, [<Display Width> * <Display Height> / 8 or 6 or 4] Valied Resoults are: 32, 24 and 16.

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
  Include                             # Root include for the package

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
BaseAddress   = <UEFI FD Base Address>|gArmTokenSpaceGuid.PcdFdBaseAddress # The base address of the FLASH Device.
Size          = <UEFI FD Size>|gArmTokenSpaceGuid.PcdFdSize        # The size in bytes of the FLASH Device
ErasePolarity = 1

# This one is tricky, it must be: BlockSize * NumBlocks = Size
BlockSize     = 0x1000
NumBlocks     = <UEFI FD NumBlocks>

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

0x00000000|<UEFI FD Size>
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

  # Disk IO
  INF MdeModulePkg/Bus/Scsi/ScsiBusDxe/ScsiBusDxe.inf
  INF MdeModulePkg/Bus/Scsi/ScsiDiskDxe/ScsiDiskDxe.inf

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

  INF MsGraphicsPkg/GopOverrideDxe/GopOverrideDxe.inf
  INF MsCorePkg/MuCryptoDxe/MuCryptoDxe.inf
  INF DfciPkg/IdentityAndAuthManager/IdentityAndAuthManagerDxe.inf
  INF DfciPkg/SettingsManager/SettingsManagerDxe.inf
  INF MsGraphicsPkg/MsUiTheme/Dxe/MsUiThemeProtocol.inf
  INF MsGraphicsPkg/RenderingEngineDxe/RenderingEngineDxe.inf
  INF MsGraphicsPkg/DisplayEngineDxe/DisplayEngineDxe.inf
  INF OemPkg/BootMenu/BootMenu.inf
  INF RuleOverride = UI QcomPkg/Applications/FrontPage/FrontPage.inf
  INF PcBdsPkg/MsBootPolicy/MsBootPolicy.inf
  INF MdeModulePkg/Universal/BootManagerPolicyDxe/BootManagerPolicyDxe.inf
  INF MdeModulePkg/Universal/RegularExpressionDxe/RegularExpressionDxe.inf
  INF DfciPkg/DfciManager/DfciManager.inf
  INF MsGraphicsPkg/OnScreenKeyboardDxe/OnScreenKeyboardDxe.inf
  INF MsGraphicsPkg/SimpleWindowManagerDxe/SimpleWindowManagerDxe.inf
  INF MsGraphicsPkg/MsEarlyGraphics/Dxe/MsEarlyGraphics.inf

  INF MsWheaPkg/HwErrBert/HwErrBert.inf
  INF MsWheaPkg/MsWheaReport/Dxe/MsWheaReportDxe.inf

  # Hardware Health (Menu) application
  INF MsWheaPkg/HwhMenu/HwhMenu.inf

  INF MsCorePkg/AcpiRGRT/AcpiRgrt.inf

  INF DfciPkg/Application/DfciMenu/DfciMenu.inf

  FILE APPLICATION = PCD(gPcBdsPkgTokenSpaceGuid.PcdShellFile) {
    SECTION PE32 = $(OUTPUT_DIRECTORY)/$(TARGET)_$(TOOL_CHAIN_TAG)/AARCH64/Shell.efi
    SECTION UI = "Shell"
  }

  FILE FREEFORM = PCD(gOemPkgTokenSpaceGuid.PcdLogoFile) {
    SECTION RAW = QcomPkg/Applications/FrontPage/Resources/BootLogo.bmp
    SECTION UI = "Logo"
  }

  FILE FREEFORM = PCD(gOemPkgTokenSpaceGuid.PcdFrontPageLogoFile) {
    SECTION RAW = QcomPkg/Applications/FrontPage/Resources/FrontpageLogo.bmp
  }

  FILE FREEFORM = PCD(gOemPkgTokenSpaceGuid.PcdLowBatteryFile) {
    SECTION RAW = QcomPkg/Applications/FrontPage/Resources/LBAT.bmp
  }

  FILE FREEFORM = PCD(gOemPkgTokenSpaceGuid.PcdThermalFile) {
    SECTION RAW = QcomPkg/Applications/FrontPage/Resources/THOT.bmp
  }

  FILE FREEFORM = PCD(gOemPkgTokenSpaceGuid.PcdVolumeUpIndicatorFile) {
    SECTION RAW = QcomPkg/Applications/FrontPage/Resources/VolumeUp.bmp
  }

  FILE FREEFORM = PCD(gOemPkgTokenSpaceGuid.PcdFirmwareSettingsIndicatorFile) {
    SECTION RAW = QcomPkg/Applications/FrontPage/Resources/FirmwareSettings.bmp
  }

  FILE FREEFORM = PCD(gOemPkgTokenSpaceGuid.PcdBootFailIndicatorFile) {
    SECTION RAW = QcomPkg/Applications/FrontPage/Resources/NoBoot.bmp
  }

  # TODO: Make this Image for every single Device
  FILE FREEFORM = PCD(gMsCorePkgTokenSpaceGuid.PcdRegulatoryGraphicFileGuid) {
    SECTION RAW = QcomPkg/Include/Resources/RegulatoryLogos.png
  }

  INF QcomPkg/UFP/ufpdevicefw.inf
  INF QcomPkg/Drivers/KernelErrataPatcher/KernelErrataPatcher.inf
  INF QcomPkg/Drivers/ColorbarsDxe/ColorbarsDxe.inf
  INF QcomPkg/Drivers/GpioButtons/GpioButtons.inf

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

`<UEFI FD Base/Size Value>` is the UEFI FD Value in the MemoryMap (uefiplat.cfg). <br />
`<UEFI FD NumBlocks>` is the Number of Blocks UEFI FD has, [<UEFI FD Size> / 0x1000].

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
Now we need the order of the Binaries in `APRIORI.inc`, Use UEFITool to get the Order:

![Preview](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/APRIORI1.png)
![Preview](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/APRIORI2.png)

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
INF AdvLoggerPkg/AdvancedFileLogger/AdvancedFileLogger.inf
INF MdeModulePkg/Universal/Acpi/BootGraphicsResourceTableDxe/BootGraphicsResourceTableDxe.inf
INF MdeModulePkg/Universal/Acpi/FirmwarePerformanceDataTableDxe/FirmwarePerformanceDxe.inf
INF MdeModulePkg/Universal/PCD/Dxe/Pcd.inf
INF QcomPkg/Drivers/SimpleFbDxe/SimpleFbDxe.inf
INF MdeModulePkg/Bus/Usb/UsbMouseAbsolutePointerDxe/UsbMouseAbsolutePointerDxe.inf
```

`ArmPsciMpServicesDxe` should be under `TimerDxe`. <br />
`AdvancedFileLogger` should be under `FvSimpleFileSystemDxe`. <br />
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
After that it should look something like [this](https://github.com/Robotix22/MU-Qcom/blob/main/Platforms/Xiaomi/viliPkg/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.c).

## Creating PlatformPei Library (Step 3.4)

If there is an Device with the same SoC as yours copy that PlatformPei and paste it in your Library Folder. <br />
In the .inf File replace the Device Codename with yours. <br />
But if there is no Device you may wana try similiar Devices.

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

![Preview](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/Synchronous-Exception.jpg)

One of these Drivers causes the Issue, In that Example it it PILDxe, you can cut it for now.
