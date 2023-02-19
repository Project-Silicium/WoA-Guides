# Adding Devices

## WARNING

If you port an Google or Sony Device there is an risk that your UFS gets wiped once you boot Windows (Will be unable to recover)

<table>
<tr><th>Sections</th></th>
<tr><td>
  
- Adding Devices
    - [Recuirements](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#device-recuirements)
    - [Creating config](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#creating-the-config-file)
    - [Creating Files](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#creating-files)
         - [Step 1](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#step-1)
         - [Step 2](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#step-2)
              - [Step 2.1](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#step-21)
              - [Step 2.2](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#step-22)
              - [Step 2.3](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#step-23)
              - [Step 2.4](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#step-24)
         - [Step 3](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#step-3)
    - [Building](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Device.md#building)

</td></tr> </table>

## Device Recuirements

To Port UEFI to your Phone, your Phone needs these things:

- Snapdragon SOC
- XBL in `/dev/block/by-name`
- fdt in `/sys/firmware`

## Creating the Config File

Every Device has its own config file to define some device specific things like: SOC <br />
Lets Create a config File for your Device, In `./configs/devices` create a file called `<Codename>.conf` <br />
It should contain at least this:
```
SOC_PLATFORM="<SOC>"
```
If your Device has multiple Models with diffrent RAM Sizes add this into the config File:
```
MULTIPLE_MEM_SIZE="TRUE"
```

## Creating Files

Struckture of the Folders for Devices:
```
./Platforms/<SOC>Pkg/
├── Devices
│   └── <Codename>
│       ├── Include
│       └── Library
│           └── PlatformMemoryMapLib
```

### Step 1

Lets begin with the `.dsc` File <br />
Create a File called `<Codename>.dsc.inc` in `./Platforms/<SOC>Pkg/Devices/<Codename>` <br />
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
  PlatformMemoryMapLib|<SOC>Pkg/Devices/<Codename>/Library/PlatformMemoryMapLib/PlatformMemoryMapLib.inf

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

  # Device Info
  gSM8350TokenSpaceGuid.PcdSmbiosSystemVendor|"<Device Manufacturer>"
  gSM8350TokenSpaceGuid.PcdSmbiosSystemModel|"<Device Model>"
  gSM8350TokenSpaceGuid.PcdSmbiosSystemRetailModel|"<Codename>"
  gSM8350TokenSpaceGuid.PcdSmbiosSystemRetailSku|"<Device Model>_<Codename>"
  gSM8350TokenSpaceGuid.PcdSmbiosBoardModel|"<Device Model>"

[PcdsDynamicDefault.common]
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoHorizontalResolution|<Display Width>
  gEfiMdeModulePkgTokenSpaceGuid.PcdVideoVerticalResolution|<Display Height>
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoHorizontalResolution|<Display Width>
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupVideoVerticalResolution|<Display Height>
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupConOutRow|150
  gEfiMdeModulePkgTokenSpaceGuid.PcdSetupConOutColumn|150
```

`<SOC>` is the Codename of your SOC. <br />
`<Codename>` is the codename of your Device. <br />
`<Start Address>` is the Start Address of the MemoryMap (uefiplat.cfg) <br />
`<RAM Size>` is the RAM size of your Device in hex. <br />
`<CPU Vector Base Address>` is the Base Address of `CPU Vectors` in MemoryMap (uefiplat.cfg) <br />
`<UEFI Stack base/Size>` is the Base/Size Address of `UEFI Stack` in MemoryMap (uefiplat.cfg) <br />

### Step 2

Now we create some files for the `.fdf` File
Create Files called: `ACPI.inc`, `APRIORI.inc`, `DXE.inc`, `FDT.inc` and `RAW.inc` in `./Platforms/<SOC>Pkg/Devices/<Codename>/Include` <br />
You can leave `ACPI.inc` and `FDT.inc` empty for now. <br />

#### Step 2.1

Lets begin with `APRIORI.inc`, to get the order of the Files you can use UEFI Tool:

![Preview](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/APRIORI1.png)
![Preview](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/APRIORI2.png)

You also need to add some extra stuff to `APRIORI.inc`:
```
INF MdeModulePkg/Universal/PCD/Dxe/Pcd.inf
INF ArmPkg/Drivers/ArmPsciMpServicesDxe/ArmPsciMpServicesDxe.inf
INF MdeModulePkg/Bus/Pci/PciBusDxe/PciBusDxe.inf
INF QcomPkg/Drivers/SimpleFbDxe/SimpleFbDxe.inf
```

`Pcd` should be under `DxeMain` <br />
`ArmPsciMpServicesDxe` should be under `TimerDxe` <br />
`PciBusDxe` should be over `Fat` <br />
`SimpleFbDxe` should be replace `DisplayDxe` <br />

#### Step 2.2

After that we can now move on to `DXE.inc`. <br />
To get the order of `DXE.inc` you can use UEFI Tool, UEFI Tool will display the order once you open the xbl File <br />
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
`SimpleFbDxe` should be replace `DisplayDxe` <br />
`UsbMouseAbsolutePointerDxe` should be under `UsbKbDxe` <br />

#### Step 2.3

Now lets move on to `RAW.inc`. <br />
Add all RAW Files that UEFI Tool displays and add them like this:
```
  FILE FREEFORM = <GUID> {
    SECTION RAW = Binaries/<Codename>/<File>.<File Extension>
    SECTION UI = "<Name>"
  }
```

#### Step 2.4

Lets move on, making Memory Map <br />
You can use `uefiplat.cfg` to make the Memory Map. <br />
Here is an Example:
```
0xEA600000, 0x02400000, "Display Reserved",  AddMem, MEM_RES, SYS_MEM_CAP, Reserv, WRITE_THROUGH_XN
```
would become in the Memory Map:
```
{"Display Reserved",  0xEA600000, 0x02400000, AddMem, MEM_RES, SYS_MEM_CAP, Reserv, WRITE_THROUGH_XN},
```
Do that with every Memory Region

### Step 3

Now we are on the Final Step. <br />
You need to extract all Binaries from xbl with UEFI Tool or what I recommend: UEFI Reader
UEFI Reader will give you an Output of Files like this as Example:
```
./Platforms/Binaries/<Codename>
├── ArmPkg
│   └── Drivers
│       ├── ArmGic
│       └── TimerDxe
├── EmbeddedPkg
│   ├── MetronomeDxe
│   └── RealTimeClockRuntimeDxe
├── FatPkg
│   └── EnhancedFatDxe
├── MdeModulePkg
│   ├── Core
│   │   └── Dxe
│   └── Universal
│       ├── CapsuleRuntimeDxe
│       ├── Console
│       │   ├── ConPlatformDxe
│       │   ├── ConSplitterDxe
│       │   └── GraphicsConsoleDxe
│       ├── DevicePathDxe
│       ├── Disk
│       │   ├── DiskIoDxe
│       │   ├── PartitionDxe
│       │   └── UnicodeCollation
│       │       └── EnglishDxe
│       ├── FvSimpleFileSystemDxe
│       ├── HiiDatabaseDxe
│       ├── PrintDxe
│       ├── ReportStatusCodeRouter
│       │   └── RuntimeDxe
│       ├── SecurityStubDxe
│       ├── StatusCodeHandler
│       │   └── RuntimeDxe
│       └── WatchdogTimerDxe
├── QcomPkg
│   ├── Application
│   │   ├── SamsungDdrApp
│   │   └── SamsungQuestApp
│   ├── Drivers
│   │   ├── ASN1X509Dxe
│   │   ├── ButtonsDxe
│   │   ├── ChipInfoDxe
│   │   ├── ClockDxe
│   │   ├── CmdDbDxe
│   │   ├── CPRDxe
│   │   ├── DALSYSDxe
│   │   ├── DDRInfoDxe
│   │   ├── DisplayDxe
│   │   ├── EmbeddedMonotonicCounter
│   │   ├── EnvDxe
│   │   ├── FeatureEnablerDxe
│   │   ├── FontDxe
│   │   ├── FvUtilsDxe
│   │   ├── GLinkDxe
│   │   ├── GpiDxe
│   │   ├── HALIOMMUDxe
│   │   ├── HWIODxe
│   │   ├── I2CDxe
│   │   ├── ICBDxe
│   │   ├── IPCCDxe
│   │   ├── MinidumpTADxe
│   │   ├── NpaDxe
│   │   ├── ParserDxe
│   │   ├── PILDxe
│   │   ├── PILProxyDxe
│   │   ├── PlatformInfoDxe
│   │   ├── PmicDxe
│   │   ├── PwrUtilsDxe
│   │   ├── QcomBds
│   │   ├── QcomWDogDxe
│   │   ├── ResetRuntimeDxe
│   │   ├── RNGDxe
│   │   ├── RpmhDxe
│   │   ├── SamsungDxe
│   │   │   ├── BoardInfoDxe
│   │   │   ├── CcicDxe
│   │   │   ├── ChgDxe
│   │   │   ├── GpioExpanderDxe
│   │   │   ├── GuidedFvDxe
│   │   │   ├── MuicDxe
│   │   │   ├── SubPmicDxe
│   │   │   └── VibDxe
│   │   ├── SdccDxe
│   │   ├── SecRSADxe
│   │   ├── SerialPortDxe
│   │   ├── ShmBridgeDxe
│   │   ├── SimpleTextInOutSerialDxe
│   │   ├── SmemDxe
│   │   ├── SPIDxe
│   │   ├── SPMIDxe
│   │   ├── SPSSDxe
│   │   ├── TLMMDxe
│   │   ├── TsensDxe
│   │   ├── TzDxe
│   │   ├── UCDxe
│   │   ├── UFSDxe
│   │   ├── ULogDxe
│   │   ├── UsbBusDxe
│   │   ├── UsbConfigDxe
│   │   ├── UsbDeviceDxe
│   │   ├── UsbfnDwc3Dxe
│   │   ├── UsbInitDxe
│   │   ├── UsbKbDxe
│   │   ├── UsbMassStorageDxe
│   │   ├── UsbMsdDxe
│   │   ├── UsbPwrCtrlDxe
│   │   ├── VariableDxe
│   │   ├── VcsDxe
│   │   ├── VerifiedBootDxe
│   │   ├── XhciDxe
│   │   └── XhciPciEmulationDxe
│   └── XBLCore
└── RawFiles
```
Copy all these Files to `./Platforms/Binaries/<Codename>`

### Step 4

Get your DTB from `/sys/firmware/fdt` and put it in `./ImageResources/DTBs/<Codename>.dtb`

### Building

Now Build your Device with:
```
./build_uefi.sh -d <Codename> -r DEBUG [-m <RAM Size>]
```

If your Device does not have `MULTIPLE_MEM_SIZE="TRUE"` in the `.conf` File `-m` is not needed
