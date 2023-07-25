# Adding SoCs

## Description

This Guide will show you how to make an UEFI Port for an Snapdragon SoC

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Adding SoCs
    - [Creating config](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/SoC.md#creating-the-config-file-step-1)
    - [Copying Files & Modify](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/SoC.md#copying-files--modify-them-step-2)
        - [SoC Folder](creating-soc-folder-step-21)
        - [Core Files](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/SoC.md#modify-dsc.inc--dec-file-step-22)
            - [.dec File](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/SoC.md#modify-dec-file-step-221)
            - [.dsc.inc File](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/SoC.md#modify-dsc.inc-file-step-222)
        - [Modify SMBios](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/SoC.md#modify-smbios-step-23)
        - [Modify Librarys](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/SoC.md#modify-librarys-step-24)

</td></tr> </table>

## Creating the Config File (Step 1)

You may noticed that every SoC has an config File in `./configs` <br />
It contains the `UEFI FD` Size Values <br />
Create a Config File in `./config` called: `<SoC Codename>.conf` with this content:
```
FD_BASE=<Value>
FD_SIZE=<Value>
```
If the SOC needs any "special" Configs add these there.

## Copying Files & Modify them (Step 2)

Struckture of Files for SoCs:
```
./Platforms/Qualcomm/<SoC Codename>Pkg/
├── Drivers
│   └── SmBiosTableDxe
│       ├── SmBiosTableDxe.c
│       └── SmBiosTableDxe.inf
├── Include
│   ├── Protocol
│   │   └── <Protocols>
├── Library
│   └── <Librarys>
├── <SOC Codename>.dec
└── <SOC Codename>.dsc
```

## Creating SoC Folder (Step 2.1)

In `./Platforms/Qualcomm/` are all SoC Folders located. <br />
Copy any SoC Folder of your chosse and rename it to `<SoC Codename>Pkg`.

## Modify .dsc.inc & .dec File (Step 2.2)

Now we modify the `.dsc.inc` & `.dec` File. <br />

## Modify .dec File (Step 2.2.1)

Lets Modify the `.dec` File. <br />
Rename the File to your SoC Codename. <br />
After that open the File and rename the old SoC Name to your SoC Name. <br />
Now we add the SoC Protocols. <br />
Go to: https://git.codelinaro.org/clo/la/abl/tianocore/edk2/ and find your SoC.

![Preview](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/DEC1.png)

Once you found your SoC go to `QcomModulePkg/QcomModulePkg.dec`. <br />
After that copy all Protocols and Guids, replace the old ones in the `.dec` File. <br />

![Preview](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/DEC2.png)
![Preview](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/DEC3.png)

And We need to download the Protocols from `QcomModulePkg/Include/Protocol` and move them into`./Platforms/Qualcomm/<SoC Codename>Pkg/Include/Protocol/` Override if asked. <br />

![Preview](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/DEC4.png)

## Modify .dsc.inc File (Step 2.2.2)

In this File we need to change a lot. <br />
Lets begin with renaming the old SoC Name to your SoC Name. <br />
After that we change `PcdArmArchTimerSecIntrNum` and `PcdArmArchTimerIntrNum` to thr right Value. <br />
If the SoC is older than SM8350 use `17` and `18` if not use `29` and `30`. <br />

`PcdGicDistributorBase` and `PcdGicRedistributorsBase` are the two Values of the interrupt-controller node in the dts. <br />
Take a look at https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/arch/arm64/boot/dts/qcom in your SoC dts to find these Values. <br />
Set `PcdAcpiDefaultOemRevision` to your SoC Name Example: `SM8350 -> 0x00008350`

Now we need to set `PcdCoreCount` and `PcdClusterCount` to the right Value, You can findout these Values by looking at the specs of the SoC.

After that we need to change SmBios Values: <br />
from this:
```
gQcomTokenSpaceGuid.PcdSmbiosProcessorModel|"Snapdragon (TM) 888 @ 2.84 GHz"
gQcomTokenSpaceGuid.PcdSmbiosProcessorRetailModel|"SM8350"
```
to this:
```
gQcomTokenSpaceGuid.PcdSmbiosProcessorModel|"Snapdragon (TM) <SoC Name> @ <SoC Speed> GHz"
gQcomTokenSpaceGuid.PcdSmbiosProcessorRetailModel|"<SoC Codename>"
```

## Modify SmBios (Step 2.3)

SmBios defines Device Infos from CPU and maybe also other Devices. <br />
Windows and Linux uses these Infos to display correct Values, <br />
Example: The CPU Name you see in Device Manager is defined in SMBios.

There are multiple Things you need to change: `SMBIOS_TABLE_TYPE4`, `SMBIOS_TABLE_TYPE7` and `SMBIOS_TABLE_TYPE17` <br />
Lets begin with `SMBIOS_TABLE_TYPE4`:

It defines some CPU Values like Speed and Clusters. <br />
Here is a template Section:
```
SMBIOS_TABLE_TYPE4 mProcessorInfoType4 = {
    {EFI_SMBIOS_TYPE_PROCESSOR_INFORMATION, sizeof(SMBIOS_TABLE_TYPE4), 0},
    1,                // Socket String
    CentralProcessor, // ProcessorType;				      ///< The
                      // enumeration value from PROCESSOR_TYPE_DATA.
    ProcessorFamilyIndicatorFamily2, // ProcessorFamily;        ///< The
                                     // enumeration value from
                                     // PROCESSOR_FAMILY2_DATA.
    2,                               // ProcessorManufacture String;
    {                                // ProcessorId;
     {
         // PROCESSOR_SIGNATURE
         0, //  ProcessorSteppingId:4;
         0, //  ProcessorModel:     4;
         0, //  ProcessorFamily:    4;
         0, //  ProcessorType:      2;
         0, //  ProcessorReserved1: 2;
         0, //  ProcessorXModel:    4;
         0, //  ProcessorXFamily:   8;
         0, //  ProcessorReserved2: 4;
     },

     {
         // PROCESSOR_FEATURE_FLAGS
         0, //  ProcessorFpu       :1;
         0, //  ProcessorVme       :1;
         0, //  ProcessorDe        :1;
         0, //  ProcessorPse       :1;
         0, //  ProcessorTsc       :1;
         0, //  ProcessorMsr       :1;
         0, //  ProcessorPae       :1;
         0, //  ProcessorMce       :1;
         0, //  ProcessorCx8       :1;
         0, //  ProcessorApic      :1;
         0, //  ProcessorReserved1 :1;
         0, //  ProcessorSep       :1;
         0, //  ProcessorMtrr      :1;
         0, //  ProcessorPge       :1;
         0, //  ProcessorMca       :1;
         0, //  ProcessorCmov      :1;
         0, //  ProcessorPat       :1;
         0, //  ProcessorPse36     :1;
         0, //  ProcessorPsn       :1;
         0, //  ProcessorClfsh     :1;
         0, //  ProcessorReserved2 :1;
         0, //  ProcessorDs        :1;
         0, //  ProcessorAcpi      :1;
         0, //  ProcessorMmx       :1;
         0, //  ProcessorFxsr      :1;
         0, //  ProcessorSse       :1;
         0, //  ProcessorSse2      :1;
         0, //  ProcessorSs        :1;
         0, //  ProcessorReserved3 :1;
         0, //  ProcessorTm        :1;
         0, //  ProcessorReserved4 :2;
     }},
    3, // ProcessorVersion String;
    {
        // Voltage;
        0, // ProcessorVoltageCapability5V        :1;
        0, // ProcessorVoltageCapability3_3V      :1;
        0, // ProcessorVoltageCapability2_9V      :1;
        0, // ProcessorVoltageCapabilityReserved  :1; ///< Bit 3, must be zero.
        0, // ProcessorVoltageReserved            :3; ///< Bits 4-6, must be
           // zero.
        0  // ProcessorVoltageIndicateLegacy      :1;
    },
    0,                     // ExternalClock;
    <Max speed of your SoC>, // MaxSpeed;
    <Max speed of your SoC>, // CurrentSpeed;
    0x41,                  // Status;
    ProcessorUpgradeOther, // ProcessorUpgrade;      ///< The enumeration value
                           // from PROCESSOR_UPGRADE.
    0,                     // L1CacheHandle;
    0,                     // L2CacheHandle;
    0,                     // L3CacheHandle;
    0,                     // SerialNumber;
    0,                     // AssetTag;
    4,                     // PartNumber;
    <Amount of Cores your SoC has>, // CoreCount;
    <Amount of Cores your SoC has>, // EnabledCoreCount;
    <Amount of Cores your SoC has>, // ThreadCount;
    0xAC,                        // ProcessorCharacteristics;
    ProcessorFamilyARM,          // ARM Processor Family;
};
```
After you modified these, we move on to `SMBIOS_TABLE_TYPE7`. <br />
Here is a template of Type 7:
```
SMBIOS_TABLE_TYPE7 mCacheInfoType7_L2 = {
    {EFI_SMBIOS_TYPE_CACHE_INFORMATION, sizeof(SMBIOS_TABLE_TYPE7), 0},
    1,     // SocketDesignation String
    0x380, // Cache Configuration
           // Cache Level        :3  (L1)
           // Cache Socketed     :1  (Not Socketed)
           // Reserved           :1
           // Location           :2  (Internal)
           // Enabled/Disabled   :1  (Enabled)
           // Operational Mode   :2  (Unknown)
           // Reserved           :6
    <Size of L2>, // Maximum Size
    <Size of L2>, // Install Size
    {
        // Supported SRAM Type
        0, // Other             :1
        1, // Unknown           :1
        0, // NonBurst          :1
        0, // Burst             :1
        0, // PiplelineBurst    :1
        0, // Synchronous       :1
        0, // Asynchronous      :1
        0  // Reserved          :9
    },
    {
        // Current SRAM Type
        0, // Other             :1
        1, // Unknown           :1
        0, // NonBurst          :1
        0, // Burst             :1
        0, // PiplelineBurst    :1
        0, // Synchronous       :1
        0, // Asynchronous      :1
        0  // Reserved          :9
    },
    0,                      // Cache Speed unknown
    CacheErrorParity,       // Error Correction
    CacheTypeInstruction,   // System Cache Type
    CacheAssociativityOther // Associativity
};

SMBIOS_TABLE_TYPE7 mCacheInfoType7_L3 = {
    {EFI_SMBIOS_TYPE_CACHE_INFORMATION, sizeof(SMBIOS_TABLE_TYPE7), 0},
    1,     // SocketDesignation String
    0x380, // Cache Configuration
           // Cache Level        :3  (L1)
           // Cache Socketed     :1  (Not Socketed)
           // Reserved           :1
           // Location           :2  (Internal)
           // Enabled/Disabled   :1  (Enabled)
           // Operational Mode   :2  (Unknown)
           // Reserved           :6
    <Size of L3>, // Maximum Size
    <Size of L3>, // Install Size
    {
        // Supported SRAM Type
        0, // Other             :1
        1, // Unknown           :1
        0, // NonBurst          :1
        0, // Burst             :1
        0, // PiplelineBurst    :1
        0, // Synchronous       :1
        0, // Asynchronous      :1
        0  // Reserved          :9
    },
    {
        // Current SRAM Type
        0, // Other             :1
        1, // Unknown           :1
        0, // NonBurst          :1
        0, // Burst             :1
        0, // PiplelineBurst    :1
        0, // Synchronous       :1
        0, // Asynchronous      :1
        0  // Reserved          :9
    },
    0,                     // Cache Speed unknown
    CacheErrorParity,      // Error Correction
    CacheTypeInstruction,  // System Cache Type
    CacheAssociativity2Way // Associativity
};
CHAR8 *mCacheInfoType7Strings[] = {"L2 Instruction", "L2 Data", "L3", NULL};
```
You can get all these Infos if you look up the specs of your SoC or find these in the dtb of your Device. <br />
If Your SoC dosen't have L3 for example then just remove it, Or if it has L1 then just add L1.

## Modify Librarys (Step 2.4)

Now we need to modify the Librarys, these are placed under `./Platforms/Qualcomm/<SoC Codename>Pkg/Library/`. <br />
In every Librarys `.inf` File rename the SoC Name to yours it should be enough for now.
