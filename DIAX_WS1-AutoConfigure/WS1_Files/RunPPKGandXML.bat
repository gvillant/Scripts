cd %~dp0
msiexec /a "VMwareWS1ProvisioningTool.msi" /qb TARGETDIR="C:\Temp\VMwareWS1ProvisioningTool" && C:\Temp\VMwareWS1ProvisioningTool\VMwareWS1ProvisioningTool\VMwareWS1ProvisioningTool.exe -a full -p .\ProvisioningPackage.ppkg -u .\unattend.xml -s --gui
