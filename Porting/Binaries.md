# Patching Binaries

## Description

This Guide will show you how to create a Patch for EFI Drivers from xbl

<table>
<tr><th>Table of Contents</th></th>
<tr><td>
  
- Patching Binaries
    - [Requirements](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Binaries.md#requirements)
    - [Method 1](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Binaries.md#requirements)
       - [Preparing](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Binaries.md#preparing-step-1)
       - [Analyze](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Binaries.md#analyzing-step-2)
       - [Patch](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Binaries.md#patching-step-3)
    - [Method 2](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/Binaries.md#method-2-creating-a-patch)

</td></tr> </table>

## Requirements

To Patch a EFI Binary you need the following things:

- The EFI Binary you want to patch
- [Ghidra](https://github.com/NationalSecurityAgency/ghidra/releases/latest)

## Method 1 (Using other patches) [Recomended]

## Preparing (Step 1)

First we need to prepare some things, Create a workspace where you patch your EFI Binary. <br />
Download and extract Ghidra somewhere where you can reach it again. <br />
Open Ghidra then go to `File -> New Project`, once you clicked it a dialog box opens. <br />
Chosse Non-Shared Project then Set the Project Dir and Name and press Finish. <br />
Now you have a new Project but the EFI Binary is still missing import the Binary `File -> Batch` Import and select your EFI Binary. <br />
You probally get two Files, The File you imported and another File that has the same name with a 0, delete the 0 File.

## Analyzing (Step 2)

After that you have now a Project with your Files but now we also need to get the Patches, You can find varios Patches [here](https://github.com/Robotix22/MU-Qcom-binaries). <br />
Chosse the Patch you want to apply, Download the unpatched and patched Version of the EFI Binary and save it somewhere where you can rech it. <br />

Create a hexdump of all EFI Binaries Files: `hexdump -C [File Name].efi > [File Name].efi.hex`, then diff the Two Files: `diff [File Name].efi.hex [File Name].patched.efi.hex`. <br />
Once you runned the Command you should get output like this:
```
┌──(robotix㉿DESKTOP-2EVF6NR)-[/mnt/c/Users/Robotix/Downloads]
└─$ diff PmicDxeLa-gts8.efi.hex PmicDxeLa-gts8.patched.efi.hex
6969c6969
< 0001c1b0  fd 7b c1 a8 c0 03 5f d6  fd 7b bf a9 fd 03 00 91  |.{...._..{......|
---
> 0001c1b0  fd 7b c1 a8 c0 03 5f d6  00 00 80 52 c0 03 5f d6  |.{...._....R.._.|
6975c6975
< 0001c210  fd 7b bf a9 fd 03 00 91  89 00 00 d0 29 75 43 f9  |.{..........)uC.|
---
> 0001c210  00 00 80 52 c0 03 5f d6  89 00 00 d0 29 75 43 f9  |...R.._.....)uC.|

┌──(robotix㉿DESKTOP-2EVF6NR)-[/mnt/c/Users/Robotix/Downloads]
└─$
```
On the left side are the Addresses where these Bytes are, usefull later, In this Example did `fd 7b bf a9` become `00 00 80 52`. <br />
You need to find that Byte Address in yours too: `cat [File Name].efi.hex | grep "fd 7b bf a9"` Replace the Address acording to the patch you want to use. <br />

If you get no Output there is also another Way to find that Location, Remember the left Addresses? Well now we need these, Import the Patched and Unpatched EFI File in ghidra in your Project. <br />
Open the unpatched File and the patched File by double clicking on them, if it asks you to analyze press Yes and Analyze. <br />
Wait until its Finisched Analyzing then copy the left address and Press G in Ghidra, that will open a dialog box, paste your address in there and press Ok. <br />

Once it took you to the function find the patches you saw in Terminal, Now also open you EFI File and go to that Location, if it does not look like the Function you look at in the patched File then scoll a bit up or down maybe you find it, if not you can't apply that patch to your File. <br />

## Patching (Step 3)

Okay, Now its time to patch your EFI File if you found the bytes, Set the bytes you just found the the patched bytes, To do that Press `SHIFT + STRG + G`. <br />
Wait until it finisches loading then change theses Values to the Values that are in the patched File present. <br />

Once you did that you can save the File: `File -> Save [File Name] as`, A dialog Box will apear, Change the Name to: `[File Name].patched.efi` and press Save. <br />

After that you only need to Export the File and implement it in the UEFI, To Export it you go to: `File -> Export Program`, again a dialog box will open, Format should be PE and if `Selection Only` is checked uncheck it and press OK. <br />

Now it will tell you it exported it and now you have a Patched File!

## Method 2 (Creating a Patch)

TODO: Add this part of the Guide
