cd %~dp0
msiexec /a "VMwareWS1ProvisioningTool.msi" /qb TARGETDIR="C:\Temp" && C:\Temp\VMwareWS1ProvisioningTool\VMwareWS1ProvisioningTool.exe -a full -p .\Dropship-Package.ppkg -u .\Dropship-unattend.xml -s --gui