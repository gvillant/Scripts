# If we are running as a 32-bit process on an x64 system, re-launch as a 64-bit process
if ("$env:PROCESSOR_ARCHITEW6432" -ne "ARM64")
{
    if (Test-Path "$($env:WINDIR)\SysNative\WindowsPowerShell\v1.0\powershell.exe")
    {
        & "$($env:WINDIR)\SysNative\WindowsPowerShell\v1.0\powershell.exe" -ExecutionPolicy bypass -NoProfile -File "$PSCommandPath"
        Exit $lastexitcode
    }
}

# Create a tag file just so Intune knows this was installed
if (-not (Test-Path "$($env:ProgramData)\Dell"))
{
    Mkdir "$($env:ProgramData)\Dell"
}
Set-Content -Path "$($env:ProgramData)\Dell\Fix-IntelDisplayDriver.ps1.tag" -Value "Installed"

# Start logging
Start-Transcript "$($env:ProgramData)\Dell\Fix-IntelDisplayDriver.log"

# Variables
$installFolder = "$PSScriptRoot\"
$DriverVersion = "27.20.100.9171" # Put here the target version
$ValidModel = "Latitude 7490"
$DriverProviderName = "Intel Corporation"

# Get Computer Model
$ComputerModel = (gwmi -class win32_Computersystem).Model

# Get all drivers that have display as deviceclass using WMI
[array]$DisplayDrivers = gwmi -class win32_PnPSignedDriver | ? { $_.DeviceClass -eq "DISPLAY" } | ? { $_.DriverProviderName -eq $DriverProviderName }

# Select description and driver's version
$DisplayDrivers | select Description, DeviceName, DriverVersion, DriverDate, DriverProviderName, InfName, InstallDate, DeviceID

# Check Computer Model
if ($ComputerModel -ne $ValidModel)
{
    Write-host "Detected Model is $($ComputerModel) does not match $ValidModel ... exiting script !"
    exit
}
# Check Display driver ProviderName
if ($DisplayDrivers.DriverProviderName -ne $DriverProviderName)
{
    Write-host "Detected Display is $($DisplayDrivers.DriverProviderName) does not match $DriverProviderName ... exiting script !"
    exit
}

# Check Display drivers count
if ($DisplayDrivers.count -eq 1) 
{
    Write-host "Found $($DisplayDrivers.DeviceName) / $($DisplayDrivers.DriverProviderName) / $($DisplayDrivers.DriverVersion) / $($DisplayDrivers.InfName)"
} 
else {
    Write-host "ERROR - Found $($DisplayDrivers.Count) matching drivers, exiting script !"
    exit
}

# Check version
if ($DisplayDrivers.DriverVersion -eq $DriverVersion)
{
    Write-host "Already installed driver version $($DisplayDrivers.DriverVersion) matches target driver version $DriverVersion ... exiting script !"
    exit
}

# Create registry key to disable DC State
Write-host "Adding registry keys under HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\"

New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" -Force
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" -Force
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0002" -Force
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0003" -Force
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0004" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" -Name "EnableDCStateinPSR" -Type "DWord" -Value "00000000" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0000" -Name "EnableDC5DC6WA" -Type "DWord" -Value "00000000" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" -Name "EnableDCStateinPSR" -Type "DWord" -Value "00000000" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0001" -Name "EnableDC5DC6WA" -Type "DWord" -Value "00000000" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0002" -Name "EnableDCStateinPSR" -Type "DWord" -Value "00000000" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0002" -Name "EnableDC5DC6WA" -Type "DWord" -Value "00000000" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0003" -Name "EnableDCStateinPSR" -Type "DWord" -Value "00000000" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0003" -Name "EnableDC5DC6WA" -Type "DWord" -Value "00000000" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0004" -Name "EnableDCStateinPSR" -Type "DWord" -Value "00000000" -Force
Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4d36e968-e325-11ce-bfc1-08002be10318}\0004" -Name "EnableDC5DC6WA" -Type "DWord" -Value "00000000" -Force

# Delete Driver
Write-host "Removing driver with pnputil. Command line is : pnputil.exe /delete-driver `"$($DisplayDrivers.InfName)`" /force"
& pnputil.exe /delete-driver `"$($DisplayDrivers.InfName)`" /force


# Install Driver igxpin.exe [-b] [-overwrite] [-l<LCID>] [-s] [-report <path>]
Write-host "Installing new driver. Command line is : igxpin.exe -overwrite -s -report `"$($env:ProgramData)\Dell`""
& "$($installFolder)Intel-UHD-Graphics-Driver_R8T3C_WIN_27.20.100.9171_A19_01\igxpin.exe" -overwrite -s -report `"$($env:ProgramData)\Dell`"

Stop-Transcript


