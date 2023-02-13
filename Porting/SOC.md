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

*NOTE: Continue Guide*
![](https://github.com/Robotix22/MU-Qcom-Guides/blob/main/Porting/DEC1.png)
