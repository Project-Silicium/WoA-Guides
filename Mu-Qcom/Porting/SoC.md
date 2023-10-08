# Adding SoCs

## Description

This Guide will show you how to make an UEFI Port for an Snapdragon SoC

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Adding SoCs
    - [Copying Files & Modify](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/SoC.md#copying-files--modify-them-step-1)
        - [SoC Folder](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/SoC.md#creating-soc-folder-step-11)
        - [Core Files](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/SoC.md#modify-dsc.inc--dec-file-step-12)
            - [.dec File](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/SoC.md#modify-dec-file-step-121)
            - [.dsc.inc File](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/SoC.md#modify-dsc.inc-file-step-122)
        - [Modify SMBios](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/SoC.md#modify-smbios-step-13)
        - [Modify Librarys](https://github.com/Robotix22/UEFI-Guides/blob/main/MU-Qcom/Porting/SoC.md#modify-librarys-step-14)

</td></tr> </table>

## Copying Files & Modify them (Step 1)

Struckture of Files for SoCs:
```
./Silicon/Qualcomm/<SoC Codename>Pkg/
├── Drivers
│   └── SmBiosTableDxe
│       ├── SmBiosTableDxe.c
│       └── SmBiosTableDxe.inf
├── Include
│   ├── Configuration
│   │   └── DeviceConfigurationMap.h
│   ├── Library
│   │   └── PlatformHobs.h
├── Library
│   └── <Librarys>
├── <SOC Codename>.dec
└── <SOC Codename>.dsc
```

## Creating SoC Folder (Step 1.1)

In `./Silicon/Qualcomm/` are all SoC Folders located. <br />
Copy any SoC Folder of your chosse and rename it to `<SoC Codename>Pkg`. <br />
NOTE: You might want to copy a SoC Folder that is the similar to yours.

## Modify .dsc.inc & .dec File (Step 1.2)

Now we modify the `.dsc.inc` & `.dec` File. <br />

## Modify .dec File (Step 1.2.1)

Lets Modify the `.dec` File. <br />
Rename the File to your SoC Codename. <br />
After that open the File and rename the old SoC Name to your SoC Name. <br />
Also Change the GUID, Generate a random one [here](https://guidgenerator.com/)

## Modify .dsc.inc File (Step 1.2.2)

In this File we need to change a lot. <br />
Lets begin with renaming the old SoC Name to your SoC Name. <br />
After that we change the Timer & Gic Value to the right Values according to your SoC. <br />
Lets Beginn with the Timer Values. <br />
First, Change the `PcdArmArchTimerFreqInHz` to the right Value, You can find that Value in your DTB in the`timer` node:
```
# NOTE: Use your DTB
timer {
  compatible = "arm,armv8-timer";
  interrupts = <0x01 0x01 0xf08 0x01 0x02 0xf08 0x01 0x03 0xf08 0x01 0x00 0xf08>;
  clock-frequency = <0x124f800>;
                         |
                  Freq In Hz Value
};
```
Convert the Hex Value to a Decimal Value. <br />
Then, We come to the interrupt Values. <br />
`PcdArmArchTimerSecIntrNum`, `PcdArmArchTimerIntrNum`, `PcdArmArchTimerVirtIntrNum` and `PcdArmArchTimerHypIntrNum` are the Interrupts.
```
# NOTE: Use your DTB
timer {
  compatible = "arm,armv8-timer";
  interrupts = <0x01 0x01 0xf08 0x01 0x02 0xf08 0x01 0x03 0xf08 0x01 0x00 0xf08>;
                      |               |                |               |
                  1st Value      2nd Value         3rd Value       4th Value
  clock-frequency = <0x124f800>;
};
```
Again, Change the Hex Values to Decimal Values. <br />
Before adding these Values to the PCDs we need to do some Maths :D<br />
```
SecIntrNum = 29 + <1st Value>
IntrNum = 30 + <2st Value>
VirtIntrNum = 27 + <3rd Value>
HypIntrNum = 26 + <4th Value>
```
After you calculated the Values, You add them to the PCDs. <br>

Now We will Change the Gic Values. <br />
`PcdGicDistributorBase` and `PcdGicRedistributorsBase` are the two Values of the `interrupt-controller` node in the dts. <br />
```
# NOTE: Use your DTB
interrupt-controller@17a00000 {
  compatible = "arm,gic-v3";
  #interrupt-cells = <0x03>;
  interrupt-controller;
  #redistributor-regions = <0x01>;
  redistributor-stride = <0x00 0x20000>;
  reg = <0x17a00000 0x10000 0x17a60000 0x100000>;
             |                  |
         1st Value          2nd Value
  interrupts = <0x01 0x09 0x04>;
  phandle = <0x01>;
};
```
`PcdGicInterruptInterfaceBase` and `PcdInterruptBaseAddress` are the same Value as `PcdGicDistributorBase`. <br />
Set `PcdAcpiDefaultOemRevision` to your SoC Name Example: `SM8350 -> 0x00008350`

Now we need to set `PcdCoreCount` and `PcdClusterCount` to the right Value, You can findout these Values by looking at the specs of the SoC.

After that we need to change SmBios Values: <br />
from this:
```
gQcomPkgTokenSpaceGuid.PcdSmbiosProcessorModel|"Snapdragon (TM) 888 @ 2.84 GHz"
gQcomPkgTokenSpaceGuid.PcdSmbiosProcessorRetailModel|"SM8350"
```
to this:
```
gQcomPkgTokenSpaceGuid.PcdSmbiosProcessorModel|"Snapdragon (TM) <SoC Name> @ <SoC Speed> GHz"
gQcomPkgTokenSpaceGuid.PcdSmbiosProcessorRetailModel|"<SoC Codename>"
```

You also need to change the UART Value, You can get it from your dts serial0 node.

## Modify SmBios (Step 1.3)

SmBios defines Device Infos from CPU and maybe also other Devices. <br />
Windows and Linux uses these Infos to display correct Values, <br />
Example: The CPU Name you see in Device Manager is defined in SMBios.

There are multiple Things you need to change: `SMBIOS_TABLE_TYPE4`, `SMBIOS_TABLE_TYPE7` and `SMBIOS_TABLE_TYPE17` <br />
Lets begin with `SMBIOS_TABLE_TYPE4`:

It defines some CPU Values like Speed and Clusters. <br />
Here is a template Section:
```
SMBIOS_TABLE_TYPE4 mProcessorInfoType4_<Cluster Name> = {
    {EFI_SMBIOS_TYPE_PROCESSOR_INFORMATION, sizeof(SMBIOS_TABLE_TYPE4), 0},
    1,                // Socket String
    CentralProcessor, // ProcessorType;          ///< The enumeration value from
                      // PROCESSOR_TYPE_DATA.
    ProcessorFamilyIndicatorFamily2, // ProcessorFamily;        ///< The
                                     // enumeration value from
                                     // PROCESSOR_FAMILY2_DATA.
    2,                               // ProcessorManufacture String;
    {                                // ProcessorId;
     {0x00, 0x00, 0x00, 0x00},
     {0x00, 0x00, 0x00, 0x00}},
    3, // ProcessorVersion String;
    {
        // Voltage;
        0, // ProcessorVoltageCapability5V        :1;
        0, // ProcessorVoltageCapability3_3V      :1;
        0, // ProcessorVoltageCapability2_9V      :1;
        0, // ProcessorVoltageCapabilityReserved  :1; ///< Bit 3, must be zero.
        0, // ProcessorVoltageReserved            :3; ///< Bits 4-6, must be
           // zero.
        1  // ProcessorVoltageIndicateLegacy      :1;
    },
    0,                     // ExternalClock;
    <Max Speed of your SoC>,                  // MaxSpeed;
    <Max Speed of your SoC>,,                  // CurrentSpeed;
    0x41,                  // Status;
    ProcessorUpgradeOther, // ProcessorUpgrade;         ///< The enumeration
                           // value from PROCESSOR_UPGRADE.
    0,                     // L1CacheHandle;
    0,                     // L2CacheHandle;
    0xFFFF,                // L3CacheHandle;
    0,                     // SerialNumber;
    0,                     // AssetTag;
    7,                     // PartNumber;
    <Amount of Cores for this Cluster>,                     // CoreCount;
    <Amount of Cores for this Cluster>,,                     // EnabledCoreCount;
    0,                     // ThreadCount;
    0xEC, // ProcessorCharacteristics; ///< The enumeration value from
          // PROCESSOR_CHARACTERISTIC_FLAGS ProcessorReserved1              :1;
          // ProcessorUnknown                :1;
          // Processor64BitCapble            :1;
          // ProcessorMultiCore              :1;
          // ProcessorHardwareThread         :1;
          // ProcessorExecuteProtection      :1;
          // ProcessorEnhancedVirtualization :1;
          // ProcessorPowerPerformanceCtrl    :1;
          // Processor128bitCapble            :1;
          // ProcessorReserved2               :7;
    ProcessorFamilyARM, // ARM Processor Family;
    0,                  // CoreCount2;
    0,                  // EnabledCoreCount2;
    0,                  // ThreadCount2;
};
```
Depending, How much Clusters you have, You need to add these to SMBios. <br />
For Example, Your SoC has 2 Clusters, Then you two of these. <br />
Change `CoreCount` and `EnabledCoreCount` to the amount of Cores the Cluster has. <br />
Then You Change `MaxSpeed` and `CurrentSpeed` to the Max Speed your SoC can. <br />
These two Values need to be in Hz Size. <br />

After you modified these, we move on to `SMBIOS_TABLE_TYPE7`. <br />
Here is a template of Type 7:
```
SMBIOS_TABLE_TYPE7 mCacheInfoType7_L1I = {
    {EFI_SMBIOS_TYPE_CACHE_INFORMATION, sizeof(SMBIOS_TABLE_TYPE7), 0},
    1,     // SocketDesignation String
    0x280, // Cache Configuration
           // Cache Level        :3  (L1)
           // Cache Socketed     :1  (Not Socketed)
           // Reserved           :1
           // Location           :2  (Internal)
           // Enabled/Disabled   :1  (Enabled)
           // Operational Mode   :2  (Unknown)
           // Reserved           :6
    <Size of L1I>, // Maximum Size
    <Size of L1I>, // Install Size
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

SMBIOS_TABLE_TYPE7 mCacheInfoType7_L1D = {
    {EFI_SMBIOS_TYPE_CACHE_INFORMATION, sizeof(SMBIOS_TABLE_TYPE7), 0},
    1,     // SocketDesignation String
    0x280, // Cache Configuration
           // Cache Level        :3  (L1)
           // Cache Socketed     :1  (Not Socketed)
           // Reserved           :1
           // Location           :2  (Internal)
           // Enabled/Disabled   :1  (Enabled)
           // Operational Mode   :2  (Unknown)
           // Reserved           :6
    <Size of L1D>, // Maximum Size
    <Size of L1D>, // Install Size
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

SMBIOS_TABLE_TYPE7 mCacheInfoType7_L2 = {
    {EFI_SMBIOS_TYPE_CACHE_INFORMATION, sizeof(SMBIOS_TABLE_TYPE7), 0},
    1,     // SocketDesignation String
    0x281, // Cache Configuration
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
    0x282, // Cache Configuration
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
CHAR8 *mCacheInfoType7Strings[] = {"L1 Instruction", "L1 Data", "L2", "L3"};
```
You can get all these Infos if you look up the specs of your SoC or find these in the dtb of your Device. <br />
If Your SoC dosen't have L3 for example then just remove it. <br />

After that We move to `SMBIOS_TABLE_TYPE17`. <br />
There you just need to change one Value: `Speed`, That should be in the Specs of your SoC. <br />
Then Moddify The Data Updates for `TYPE4`, `TYPE7` and `TYPE17` according to what you changed before.

## Modify Librarys (Step 1.4)

Now we need to modify the Librarys, these are placed under `./Silicon/Qualcomm/<SoC Codename>Pkg/Library/`. <br />
In every Librarys `.inf` File rename the SoC Name to yours it should be enough for now.
