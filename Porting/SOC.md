# Adding SOCs

**WARNING: This is still underconstruction!**

<table>
<tr><th>Sections</th></th>
<tr><td>
  
- Adding SOCs
    - [Creating config](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/SOC.md#step-1)
    - [Copying Files & Modify](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/SOC.md#step-2)
    - [Building](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/SOC.md#step-3)

</td></tr> </table>

## Creating the Config File

You may noticed that every SOC has an config File in `./configs` <br />
It contains the `UEFI FD` Size Values <br />
Create a Config File in `./config` called: `<SOC>.conf` with this content:
```
FD_BASE=<Value>
FD_SIZE=<Value>
```
If the SOC needs any "special" Configs add these there.

## Copying Files & Modify them
### Step 1

In `./Platforms` are all SOC Folders located. <br />
Copy any SOC Folder and rename it to `<SOC>Pkg`.

### Step 2
#### Step 2.1

Now we come to modifying the SOC Files <br />
First we rename all Files that needs to be renamed <br />
The Files we need to rename are: `<SOC>.dsc, <SOC>.fdf, <SOC>.dec` <br />
Rename these Files to the Name of your SOC.

#### Step 2.2

Lets begin Modifying the Files. <br />
In `<SOC>.dec` Replace the old SOC name with your SOC Name <br />
Then we replace all Protocols and Guids <br />
As you can see the source of the Protocols and Guids are noted <br />
Go to that Source Website and search your SOC:

![Preview](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/DEC1.png)

Then go to `QcomModulePkg/QcomModulePkg.dec` <br />
And copy all Protocols:

![Preview](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/DEC2.png)

Also do that with the Guids:

![Preview](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/DEC3.png)

After that go to `QcomModulePkg/Include/Protocol` and Download all Protocols:

![Preview](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/DEC4.png)

Then Move all these Files into `./Platforms/<SOC>Pkg/Include/Protocol` Override if asked. <br />
After that we now need to change SOC SMBios definition from this:
```
gSM8350TokenSpaceGuid.PcdSmbiosProcessorModel|"Snapdragon (TM) 888 @ 2.84 GHz"|VOID*|0x0000a301
gSM8350TokenSpaceGuid.PcdSmbiosProcessorRetailModel|"SM8350"|VOID*|0x0000a302
```
to this:
```
g<SOC>TokenSpaceGuid.PcdSmbiosProcessorModel|"Snapdragon (TM) <SOC Name> @ <SOC Speed> GHz"|VOID*|0x0000a301
g<SOC>TokenSpaceGuid.PcdSmbiosProcessorRetailModel|"<SOC>"|VOID*|0x0000a302
```

#### Step 2.2

Now we move on to the `<SOC>.dsc` File we need to change some things also here. <br />
Lets begin with renaming, Rename every old SOC name to your SOC Name. <br />
Then set `USE_PHYSICAL_TIMER` to `TRUE` or `FALSE` according to the SOC <br />
Now we need to set `gArmTokenSpaceGuid.PcdArmArchTimerSecIntrNum` and `gArmTokenSpaceGuid.PcdArmArchTimerIntrNum` to the right Value:

If the SOC is older than SM8350 use `17` and `18`, If your SOC is newer than SM8350 use `29` and `30`

Next we set `gArmTokenSpaceGuid.PcdGicDistributorBase` and `gArmTokenSpaceGuid.PcdGicRedistributorsBase` to the right Value:

If you port a SOC you probaly port a Device too, In the Devices dtb search for `interrupt-controller`, under `reg` the first Value is `gArmTokenSpaceGuid.PcdGicDistributorBase` and the thirt Value is `gArmTokenSpaceGuid.PcdGicRedistributorsBase`

`gEfiMdeModulePkgTokenSpaceGuid.PcdAcpiDefaultOemRevision` is the SOCs codename Exapmle: SM8350 -> 0x00008350
`gEmbeddedTokenSpaceGuid.PcdInterruptBaseAddress` is the same Value as `gArmTokenSpaceGuid.PcdGicRedistributorsBase`

Now we need to set `gArmPlatformTokenSpaceGuid.PcdCoreCount` and `gArmPlatformTokenSpaceGuid.PcdClusterCount` to the right Value, You can findout these Values by looking at the specs of the SOC

#### Step 2.3

Next we modify the `<SOC>.fdf` File
Rename the old SOC name to the new SOC name, thats literly it.

### Step 2.4

Now we need to modify SmBios to match it with the SOC you port.

*NOTE: Contine Guide*
