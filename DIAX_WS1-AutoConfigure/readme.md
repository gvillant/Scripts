Full PDF documentation with images available here : https://github.com/gvillant/Scripts/raw/main/DIAX_WS1-AutoConfigure/USB%20Key%20Restore%20Instructions%20for%20Dell%20Ready%20Image%20and%20Workspace%20One%20v1.0.pdf

# How to create a USB dongle to restore devices with Dell Ready Image and Workspace One Dropship Offline/Online

VERSION 1.0 (30 August 2022) by Gaetan_villant@dell.com
```
This documentation is divided into multiple parts:

# Contents

**Introduction** ............................................................................................................................................ 1

**Step 1 :** Create the standard Dell USB restore key with Dell Image Assist ................................................. 2

**Step 2** : Customize the key to support Dropship Offline with the customer’s **PPKG** and **unattend** files. ... 6

**Step 3** : Restore the target system ........................................................................................................... 9

**Explanations** ......................................................................................................................................... 10

References ............................................................................................................................................ 13

# Introduction

```
There are many reasons why it is necessary to reimage a machine.
Although it is always possible to use so-called traditional technologies such as MDT or
ConfgMgr, one of the simplest and most effective methods remains the USB key.
```
```
The following procedure is based on the Dell Image Assist tool, as well as generic images
validated by Dell, called "Ready Images".
This technique has the advantage of restoring the state of the machine as it left the Dell factory.
Here are the main features of this method:
```
- Installation without assistance
- Injection of hardware drivers and possible support for several models
- Import PPKG and unattend.xml files for Dropship Offline or Online

```
Hardware Prerequisites :
```
- One USB key with a minimum size of 32 GB (64GB recommended)
** **Note** ** A larger USB might be required. Depends on the count and size of the following files :
Ready image Windows Wim, Dell Family driver’s pack and Workspace One PPKG provisioning
package
- A Dell machine

```
Approximative time required to build the key, excluding downloading time: 1 hour
```

# Step 1 : Create the standard Dell USB restore key with Dell Image Assist

1. **Download the prerequisites files** :
    - Dell Image Assist (= DIAX Tool)
       o available on Techdirect : https://techdirect.dell.com/Portal/DellImageAssist.aspx
    - Dell Ready Image (Windows 10/11 **WIM file** provided by Dell)
       o ask your Dell PM CS, you will receive a Onedrive link with the requested image.
    - Dell Family Driver Pack that matches the system on which you are deploying the image.
       o https://www.dell.com/support/kbdoc/en-us/000180534/dell-family-driver-packs
       o You can download multiple Family Driver packs to support multiple models
2. **Unzip** the **DIAX tool** to a Windows 10 or 11 desktop.
3. **Edit** the **ImageAssist.exe.Config** file.
    Change the following line:
    _<add key="SkipApplicationLaunchValidations" value="_ **_false_** _" />_ to _value=“_ **_true_** _”_
    Save the file.
4. **Run** the **ImageAssist.exe** (admin rights required)

```
User Account Control | Click “Yes”
```
5. **Welcome** to Image Assist


6. **Terms** and **Conditions**

```
Scroll the Terms and Conditions | Click “Next”
```
7. Which type of image do you want to create?

Select “Image Assist Dynamic – (Recommended)” | Click “Next”

8. Pre-Installation Dynamic Validation

Pre-Installation Dynamic Validation | “Click Next”


9. Welcome to Image Assist Dynamic

```
Select the Gear | Click “Additional Tools”
```
10. Create USB Drive or ISO File

```
Click “CREATE”
```
11. Create USB Drive or ISO File

```
Insert your USB Key.
```
12. Select the USB key previously connected to the system.
    Verify “Bootable USB” is selected | Verify You have selected the correct USB Key
    | Click “CREATE USB”
    The creation time for the USB key varies by system. 13 - 14 minutes in this example.


Click “OK” | Close Image Assist

13. Copy the driver’s pack(s) to the 2nd partition “ **Dell_Driver_Packs_Local** ” folder on the USB key.
    **Note** **Do Not Extract** the Family Driver’s Pack
14. Copy the Ready Image (provided in OneDrive download link) to the 2nd partition “ **Dell_Images** ”
    folder on the USB key.

Well done! At this stage, you have a “ **standard** ” Dell Image Assist restore USB key.
This key can reinstall Windows and hardware drivers only. To configure this key to support restoring the
Workspace One Dropship Offline/Online, proceed to the next step.


# Step 2 : Customize the key to support Dropship Offline with the

# customer’s PPKG and unattend files.

1. **Download the prerequisites files** :
    - Sample files
       o available on my Github account:
          https://github.com/gvillant/Scripts/raw/main/DIAX_WS1-AutoConfigure.zip
    - VMware provisioning Tool
       o Connect to https://my.workspaceone.com
       o Download the tool from here:
          https://resources.workspaceone.com/view/r3tpb78l9z8dn6wpjwbt/en
    - If you want to prepare your device for Dropship **Offline** (with your custom PPKG and
       unattend file) you need to prepare and download these two files from your tenant:
          o **Custom PPKG** file
          o **Custom Unattend.xml** file
    - If you want to prepare your device for Dropship **Online** , you need to download the generic
       PPKG and unattend.xml files.
          o Connect to https://my.workspaceone.com
          o Download the “generic bundle” from here:
             https://resources.workspaceone.com/view/wpjykslvpplktqhsr394/en


2. Extract the file **DIAX_WS1-AutoConfigure.zip**
3. Copy the 3 following items from the extracted **DIAX_WS1-AutoConfigure folder** to the “ **Dell_Tools”**
    folder in the **first partition** of the USB key ( **IA_DYNAMIC** ).
       - File **after_restore.cmd**
       - File **AutoRestore.xml**
       - Folder **AuditMode**
4. Edit the **AutoRestore.xml** file, modify the <WimFileNAme> value to reflect your Wim file name
    (located in the **“Dell_Images”** folder.
5. Copy the folder “ **WS1_Files** ” from the extracted **DIAX_WS1-AutoConfigure folder** to the root of the
    **second partition** of the USB key ( **IA_DYNAMIC_DATA** ).


6. Extract the file “ **VMwareWS1ProvisioningTool 3.3 GA.zip** ” and copy the file
    “ **VMwareWS1ProvisioningTool.msi** ” to the folder “ **WS1_Files** ” in the second partition of the USB
    key.
7. Copy your **PPKG** and **unattend.xml** files to the folder “ **WS1_Files** ” and rename the files as following:
    - **ProvisioningPackage.ppkg**
    - **Unattend.xml**

Congratulations, at this stage you have a USB key with DIAX setup to run an unattended Wim restore
and WS1 PPKG import.


# Step 3 : Restore the target system

**WARNING: the device will be formatted, erasing all data (user’s files, software, settings ...) without
prompting. To be used knowingly!**

1. Insert the USB key on the target system
2. Start up the device using the power button
3. Press F12 to start the Boot menu, and select the USB bootable device.
    ** Note **: additional BIOS settings or Password could be required, depending on your
environment.
4. This will format the drive, restore the image, inject drivers, and copy the unattend.xml and ppkg
    files. Then the system will reboot in audit mode, install the ws1 provisioning tool then import the
    ppkg and unattend.xml.
5. After the successful import, the device will shut down automatically.
6. The device is ready to be started, the next startup will execute your unattend.xml.

Well done! Your device is reimaged with the Dell Ready Image and applications staged inside the PPKG
are installed.
Mission accomplished: **the device is in the same condition as it left the Dell factory.**


# Explanations

So what’s happen? Here is how the solution works, demystified, step by step.

1. **Boot on USB key** starts the **DIAX** Tool.
2. **DIAX unattended deployment.**
DIAX will automatically search for the file **AutoRestore.xml**. This file is an unattended answer file, that
can be used to automate the imaging steps.
The sections we are interested in are:
- WimFileName,
- LocalImageFileName
- AutoRestorePartitions,
- PromptUserBeforeRestore,
- AfterRestoreOption

DIAX kicks off a fully unattended installation based on the xml file settings.

3. DIAX formats and partitions the drive based on AutoRestore.xml value.
4. DIAX Applies the Wim file based on AutoRestore.xml value.
5. DIAX Injects the drivers.


DIAX will parse all the *.cab files staged in the folder “ **Dell_Driver_Packs_Local** ” and will select the best
suitable file based on the computer model and Wim file version.
DIAX supports only the **family driver’s cabs** , **not the model-based** files.
Do not extract the zip file.

6. DIAX **after_restore.cmd**
DIAX will automatically search for the file “ **after_restore.cmd** ”.
This file is automatically executed at the end of the restoration.

The script copy the AuditMode unattend.xml to the Panther folder.
The unattend.xml file setup the device to start in “Audit mode” for the next boot.

7. DIAX restarts automatically the device based on AutoRestore.xml value
8. The device execute the “Audit mode” unattend.xml file and starts Audit mode.
The device executes the “Asynchronous command” and starts the script “RunPPKGandXML.bat”


9. The script “RunPPKGandXML.bat” executes the following actions:
    - install the provisioning Tool to "C:\Temp\VMwareWS1ProvisioningTool"
    - run the provisioning tool with the following command line:
       o **VMwareWS1ProvisioningTool.exe -a full -p .\ProvisioningPackage.ppkg -**
          **u .\unattend.xml -s –gui**
    - The tool imports the provisioning package, copy the “ **custom** ” unattend.xml, show the gui
       and automatically shut down the device after a successful operation.
10. The next start will execute the “custom” unattend.xml file, then depending your environment
    and settings, it will kick off an administrator session autologon, execute additional commands,
    optionally runs DWEST, enrolls the device to the UEM, join your Active Directory domain ...


# References

```
VMware Workspace ONE Provisioning Tool
Release Notes
```
```
https://docs.vmware.com/en/VMware-
Workspace-ONE-UEM/services/rn/vmware-
workspace-one-provisioning-tool-release-
notes/index.html#workspace-one-provisioning-
tool-v
Mode (microsoft-windows-deployment-reseal-
mode)
```
```
https://docs.microsoft.com/en-us/windows-
hardware/customize/desktop/unattend/microsoft-
windows-deployment-reseal-mode
Drop Ship Provisioning: Workspace ONE
Operational Tutorial
```
```
https://techzone.vmware.com/drop-ship-
provisioning-workspace-one-operational-tutorial
Image Assist Support Information https://www.dell.com/support/home/en-
us/product-support/product/dell-imageassist/docs
```

