# Adding Devices

If you have any issues ask on our [Discord](https://discord.gg/Dx2QgMx7Sv).

## Description

This Guide will show you how to create an minimal UEFI Port for your Device. <br />
If you want to make the Port better with booting Windows/Linux as Example follow the [Extra Sutff](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Extra.md) Guide.

## WARNING

**Booting Windows/Linux on Sony/Google Device will wipe your UFS Clean! (Unable to recover)**

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Adding Devices
    - [Requirements](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#device-recuirements)
    - [Copying Files](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#copying-files-step-1)
    - [Creating Config](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#creating-the-config-file-step-2)
    - [Creating Files](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#creating-files-step-3)
         - [Creating dsc.inc](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#creating-dscinc-file-step-31)
         - [Creating fdf.inc Files](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#creating-fdfinc-files-step-32)
              - [Creating ACPI.inc](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#creating-acpiinc-step-321)
              - [Creating APRIORI.inc](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#creating-aprioriinc-step-322)
              - [Creating DXE.inc](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#creating-dxeinc-step-323)
              - [Creating RAW.inc](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#creating-rawinc-step-324)
              - [Creating FDT.inc](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#creating-fdtinc-step-325)
         - [Creating MemoryMap](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#creating-platformmemorymapc-file-step-33)
    - [Building](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#building)
    - [Troubleshooting](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#troubleshooting)
         - [DxeCore](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#dxecore)
         - [Crash](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#device-rebootsgets-stuck-on-something)
         - [Synchronous Exception](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#synchronous-exception)

</td></tr> </table>

## Device Requirements

To Port UEFI to your Phone, it needs the following things:

- an Snapdragon SOC
- XBL in `/dev/block/by-name`
- fdt in `/sys/firmware`

## Copying Files (Step 1)

Lets begin with Copying Files. <br />
Copy the fdt File from `/sys/firmware` and Place it as `<Device Codename.dtb>` under `./ImageResources/DTBs/`. <br />
Extract your xbl from `/dev/block/by-name` and Place it somewhere you can reach it. <br />
After Copying the xbl File extract all UEFI Binaries from it with [UEFIReader](https://github.com/WOA-Project/UEFIReader). <br />
Now Move all the output Files from xbl in `./Platforms/Binaries/<Device Codename>/`.

## Creating the Config File (Step 2)

Every Device has its own config file to define some device specific things like: SOC. <br />
Create a File called `<Codename>.conf` in `./configs/devices/`. <br />
It should contain at least this:
```
SOC_PLATFORM="<SOC Codename>"
```

## Creating Files (Step 3)

Struckture of the Device Files:
```
./Platforms/<SOC Codename>Pkg/
├── Devices
│   └── <Device Codename>
│       ├── Include
|       |   ├── APRIORI.inc
|       |   ├── DXE.inc
|       |   ├── RAW.inc
|       |   ├── FDT.inc
|       |   └── ACPI.inc
|       |
│       ├── Library
│       |   └── PlatformMemoryMapLib
|       |       ├── PlatformMemoryMapLib.c
|       |       └── PlatformMemoryMapLib.inf
|       |
|       └── <Device Codename>.dsc.inc
```

## Creating .dsc.inc File (Step 3.1)

Lets begin with the `.dsc.inc` File <br />
Create a File called `<Device Codename>.dsc.inc` in `./Platforms/<SOC Codename>Pkg/Devices/<Device Codename>` <br />
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

[LibraryClasses.common]
  PlatformMemoryMapLib|<SOC Codename>Pkg/Devices/<Device Codename>/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.inf

[PcdsFixedAtBuild.common]
  gArmTokenSpaceGuid.PcdSystemMemoryBase|<Start Address>         # Starting address
  gArmTokenSpaceGuid.PcdSystemMemorySize|<RAM Size>              # <RAM Size> GB Size

  gArmTokenSpaceGuid.PcdCpuVectorBaseAddress|<CPU Vector Base Address>

  gEmbeddedTokenSpaceGuid.PcdPrePiStackBase|<UEFI Stack Base>
  gEmbeddedTokenSpaceGuid.PcdPrePiStackSize|<UEFI Stack Size>

  # Simple FrameBuffer
  gQcomTokenSpaceGuid.PcdMipiFrameBufferWidth|<Display Width>
  gQcomTokenSpaceGuid.PcdMipiFrameBufferHeight|<Display Height>
  gQcomTokenSpaceGuid.PcdMipiFrameBufferPixelBpp|<Display Bpp>

  # Simple Init
  gSimpleInitTokenSpaceGuid.PcdGuiDefaultDPI|320

  # Device Info
  gQcomTokenSpaceGuid.PcdSmbiosSystemVendor|"<Device Manufacturer>"
  gQcomTokenSpaceGuid.PcdSmbiosSystemModel|"<Device Model>"
  gQcomTokenSpaceGuid.PcdSmbiosSystemRetailModel|"<Codename>"
  gQcomTokenSpaceGuid.PcdSmbiosSystemRetailSku|"<Device Model>_<Device Codename>"
  gQcomTokenSpaceGuid.PcdSmbiosBoardModel|"<Device Model>"

[PcdsDynamicDefault.common]
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoHorizontalResolution|<Display Width>
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoVerticalResolution|<Display Height>
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoHorizontalResolution|<Display Width>
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoVerticalResolution|<Display Height>
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupConOutRow|150
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupConOutColumn|150
```

`<Start Address>` is the Start Address of the MemoryMap (uefiplat.cfg) <br />
`<RAM Size>` is the RAM size of your Device in hex. <br />
`<CPU Vector Base Address>` is the Base Address of `CPU Vectors` in MemoryMap (uefiplat.cfg) <br />
`<UEFI Stack base/Size>` is the Base/Size Address of `UEFI Stack` in MemoryMap (uefiplat.cfg) <br />

## Creating .fdf.inc Files (Step 3.2)

Now we create some files for the `.fdf` File

## Creating ACPI.inc (Step 3.2.1)

Lets begin with `ACPI.inc`, Create `ACPI.inc` in `./Platforms/<SOC Codename>Pkg/Devices/<Device Codename>/Include/`. <br />
After Creating the File you can add ACPI Tables **If your SOC has already ACPITables in the Folder!** otherwise leave it empty. <br />
If there are ACPI Tables add this to your `ACPI.inc`:
```
FILE FREEFORM = 7E374E25-8E01-4FEE-87F2-390C23C606CD {
# SECTION RAW = SM8350Pkg/AcpiTables/APIC.aml
  SECTION RAW = SM8350Pkg/AcpiTables/APIC.UniCore.aml
# SECTION RAW = SM8350Pkg/AcpiTables/BERT.aml
# SECTION RAW = SM8350Pkg/AcpiTables/BGRT.aml
# SECTION RAW = SM8350Pkg/AcpiTables/CSRT.aml
# SECTION RAW = SM8350Pkg/AcpiTables/DBG2.aml
  SECTION RAW = SM8350Pkg/AcpiTables/DSDT_minimal.aml
  SECTION RAW = SM8350Pkg/AcpiTables/FACP.aml
# SECTION RAW = SM8350Pkg/AcpiTables/FPDT.aml
  SECTION RAW = SM8350Pkg/AcpiTables/GTDT.aml
# SECTION RAW = SM8350Pkg/AcpiTables/IORT.aml
# SECTION RAW = SM8350Pkg/AcpiTables/MCFG.aml
# SECTION RAW = SM8350Pkg/AcpiTables/MSDM.aml
# SECTION RAW = SM8350Pkg/AcpiTables/PPTT.aml
# SECTION RAW = SM8350Pkg/AcpiTables/SPCR.aml
# SECTION RAW = SM8350Pkg/AcpiTables/TPM2.aml
# SECTION RAW = SM8350Pkg/AcpiTables/XSDT.aml
  SECTION RAW = QcomPkg/AcpiTables/common/SSDT.aml
  SECTION RAW = QcomPkg/AcpiTables/common/TPMDev.aml
  SECTION RAW = QcomPkg/AcpiTables/common/SoftwareTpm2Table.aml
  SECTION UI = "AcpiTables" 
}
```

## Creating APRIORI.inc (Step 3.2.2)

Now we continue with `APRIORI.inc`, Create `APRIORI.inc` in `./Platforms/<SOC Codename>Pkg/Devices/<Device Codename>/Include/`. <br />
Now we need the order of the Binaries in `APRIORI.inc`, Use UEFITool to get the Order:

![Preview](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/APRIORI1.png)
![Preview](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/APRIORI2.png)

Next we place all the Binaries in `APRIORI.inc` like this:
```
INF <Path to .inf File>
```
If the Binary is an Application use `APPLICATION` instead of `DRIVER`. <br />
After you ordered and added all the Files you also need to add some extra stuff to `APRIORI.inc`:
```
INF MdeModulePkg/Universal/PCD/Dxe/Pcd.inf
INF ArmPkg/Drivers/ArmPsciMpServicesDxe/ArmPsciMpServicesDxe.inf
INF MdeModulePkg/Bus/Pci/PciBusDxe/PciBusDxe.inf
INF QcomPkg/Drivers/SimpleFbDxe/SimpleFbDxe.inf
```

`Pcd` should be under `DxeMain` <br />
`ArmPsciMpServicesDxe` should be under `TimerDxe` <br />
`PciBusDxe` should be over `Fat` <br />
`SimpleFbDxe` should replace `DisplayDxe` <br />

## Creating DXE.inc File (Step 3.2.3)

After that we can now move on to `DXE.inc`, Create `DXE.inc` in `./Platforms/<SOC Codename>Pkg/Devices/<Device Codename>/Include/`. <br />
Now again we need the Order, To get the order of `DXE.inc` Open xbl in UEFITool and you will already see the order. <br />
Again we place all the Binaries like this:
```
INF <Path to .inf>
```
Again if the Binary is an Application use `APPLICATION` instead of `DRIVER`. <br />
Also here again you need to add some extra Stuff:
```
INF MdeModulePkg/Universal/MemoryTest/NullMemoryTestDxe/NullMemoryTestDxe.inf
INF ArmPkg/Drivers/ArmPsciMpServicesDxe/ArmPsciMpServicesDxe.inf
INF AdvLoggerPkg/AdvancedFileLogger/AdvancedFileLogger.inf
INF MdeModulePkg/Universal/Acpi/BootGraphicsResourceTableDxe/BootGraphicsResourceTableDxe.inf
INF MdeModulePkg/Universal/Acpi/FirmwarePerformanceDataTableDxe/FirmwarePerformanceDxe.inf
INF MdeModulePkg/Universal/PCD/Dxe/Pcd.inf
INF QcomPkg/Drivers/SimpleFbDxe/SimpleFbDxe.inf
INF MdeModulePkg/Bus/Usb/UsbMouseAbsolutePointerDxe/UsbMouseAbsolutePointerDxe.inf
```

`NullMemoryTestDxe` should be under `EmbeddedMonotonicCounter` <br />
`ArmPsciMpServicesDxe` should be under `TimerDxe` <br />
`AdvancedFileLogger` should be under `FvSimpleFileSystemDxe` <br />
`BootGraphicsResourceTableDxe` should be under `BdsDxe` <br />
`FirmwarePerformanceDxe` should be under `BootGraphicsResourceTableDxe` <br />
`Pcd` should be under `FirmwarePerformanceDxe` <br />
`SimpleFbDxe` should replace `DisplayDxe` <br />
`UsbMouseAbsolutePointerDxe` should be under `UsbKbDxe` <br />

## Creating RAW.inc (Step 3.2.4)

Now lets move on to `RAW.inc`. <br />
Add all RAW Files that UEFI Tool displays and add them like this:
```
FILE FREEFORM = <GUID> {
  SECTION RAW = Binaries/<Codename>/<File>.<File Extension>
  SECTION UI = "<Name>"
}
```

## Creating FDT.inc (Step 3.2.5)

After Creating RAW.inc we now add FDT.inc. <br />
Your FDT.inc should contain this:
```
# Mainline DTB
#FILE FREEFORM = 25462CDA-221F-47DF-AC1D-259CFAA4E326 {
#  SECTION RAW = <SOC Codename>Pkg/FdtBlob/<SOC Codename>-<Device Model>.dtb
#}

# Downstream DTB
FILE FREEFORM = 25462CDA-221F-47DF-AC1D-259CFAA4E326 {
  SECTION RAW = ImageResources/DTBs/<Device Codename>.dtb
}
```
If you have an mainline DTB for your Device add it to `./Platforms/<SOC Codename>/FdtBlob/`. <br />
then uncomment the Mainline DTB part and comment Downstream DTB part out. <br />

## Creating PlatformMemoryMap.c File (Step 3.3)

Lets move on making Memory Map. <br />
We will use uefiplat.cfg to create the Memory Map. <br />
Create `PlatformMemoryMap.c` in `./Platforms/<SOC Codename>Pkg/Devices/<Device Codename>/Library/`. <br />
Here is an template:
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

Place all `DDR` Memory Regions under `DDR Regions` in `PlatformMemoryMap.c`, Example:
```
0xEA600000, 0x02400000, "Display Reserved",  AddMem, MEM_RES, SYS_MEM_CAP, Reserv, WRITE_THROUGH_XN
```
would become in the Memory Map:
```
{"Display Reserved",  0xEA600000, 0x02400000, AddMem, MEM_RES, SYS_MEM_CAP, Reserv, WRITE_THROUGH_XN},
```
Do that with every Memory Region but if an `#` is infront of an Memory Region do not add it. <br />
Also here you need to replace something, Replace `UEFI FD` and `DXE Heap` with the Values for your SOC Example:
```
{"DXE Heap",          0xA0000000, 0x2E000000, AddMem, SYS_MEM, SYS_MEM_CAP, Conv,   WRITE_BACK},
{"UEFI FD",           0xD0000000, 0x00600000, AddMem, SYS_MEM, SYS_MEM_CAP, BsData, WRITE_BACK},
```
After that it should look something like [this](https://github.com/Robotix22/MU-Qcom/blob/main/Platforms/SM6115Pkg/Devices/lime/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.c).

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

![Preview](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Synchronous-Exception.jpg)

One of these Drivers causes the Issue, In that Example it it PILDxe, you can cut it for now.
