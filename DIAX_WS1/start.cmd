@echo off

setlocal enabledelayedexpansion

echo Waiting for System Drive to be ready...

If exist %USBDrive%Dell_Tools\ImageAssistPE.exe (
xcopy %USBDrive%Dell_Tools x:\windows\system32\ClassicPeApplication /Y /S >NUL
echo copied dependent files successfully)

If exist %USBDrive%Dell_Tools\VMware\VMwareWS1ProvisioningTool.msi (
md O:\windows\Panther\Unattend >NUL
xcopy %USBDrive%Dell_Tools\VMware\ O:\windows\Panther\Unattend /Y /S >NUL
echo copied VMware files successfully)

start x:\windows\system32\LogZipper\LogZipper.exe
start x:\windows\system32\ClassicPeApplication\ImageAssistPE.exe

:eof