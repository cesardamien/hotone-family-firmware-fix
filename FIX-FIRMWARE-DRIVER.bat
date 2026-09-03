@echo off
:: =====================================================================
::  FIX-FIRMWARE-DRIVER.bat  -  all-in-one Windows 11 fix for Valeton /
::  Hotone / Sonicake pedals: pedal not detected by the Suite (no NAM/IR
::  transfer) and firmware update stuck at 0% on the update screen.
::
::  HOW TO USE: connect the pedal in whatever state it is in (normal mode
::  if the Suite does not see it; on its "Firmware Update / Restore" screen
::  if the update stops at 0%), double-click this file, click "Yes" on the
::  Windows permission prompt. A log opens when it finishes. Then try again.
::  Normal mode and update mode are DIFFERENT devices for Windows: if you
::  fixed the connection and the update later stops at 0%, run this again
::  with the pedal on the update screen.
::
::  Everything this file does is written below in plain PowerShell.
::  Open it in Notepad to read it. Source + docs:
::  https://github.com/cesardamien/hotone-family-firmware-fix
:: =====================================================================
setlocal
set "PS=%TEMP%\hotone-firmware-fix.ps1"
powershell -NoProfile -ExecutionPolicy Bypass -Command "$l = Get-Content -LiteralPath '%~f0'; $i = [Array]::IndexOf($l, '#__POWERSHELL_STARTS_HERE__'); $l[($i+1)..($l.Count-1)] | Set-Content -LiteralPath '%PS%' -Encoding UTF8"
powershell -NoProfile -ExecutionPolicy Bypass -File "%PS%" -LogDir "%~dp0." %*
endlocal
exit /b
#__POWERSHELL_STARTS_HERE__
<#
.SYNOPSIS
    Fixes firmware updates that freeze at 0% on Windows 11 for Valeton, Hotone
    and Sonicake devices (USB vendor ID 84EF).

.DESCRIPTION
    Since Windows MIDI Services shipped (February 2026), Windows 11 binds its new
    MIDI class driver (usbmidi2.inf) to any USB-MIDI device. The Valeton / Hotone
    firmware updaters can only talk to the device through the legacy USB Audio
    class driver (wdma_usb.inf / usbaudio.sys).

    The catch: when a pedal enters firmware-update (bootloader) mode it shows up
    as a DIFFERENT USB device (different Product ID). Swapping the driver on the
    pedal in normal mode does nothing for the bootloader device, and Device
    Manager frequently hides "USB Audio Device" from the compatible-driver list.

    This script finds every VID_84EF device that is currently connected, and
    forces the in-box USB Audio class driver onto it using the same Windows API
    Device Manager uses for "Have Disk..." installs. It logs everything to a
    text file and opens it when done.

.PARAMETER Diagnose
    Only list the connected devices and their current drivers. Makes no changes
    and does not require administrator rights.

.PARAMETER VendorId
    USB vendor ID to target. Default: 84EF (Valeton / Hotone / Sonicake).

.EXAMPLE
    .\Fix-FirmwareDriver.ps1
    .\Fix-FirmwareDriver.ps1 -Diagnose

.NOTES
    Project: https://github.com/cesardamien/hotone-family-firmware-fix
    License: MIT
#>
[CmdletBinding()]
param(
    [switch]$Diagnose,
    [string]$VendorId = "84EF",
    [string]$LogDir = ""
)

$ErrorActionPreference = "Continue"
if (-not $LogDir) { $LogDir = $PSScriptRoot }
$LogPath = Join-Path $LogDir "firmware-fix-log.txt"
$Inf     = Join-Path $env:WINDIR "INF\wdma_usb.inf"

function Log {
    param([string]$Message)
    $line = "[{0}] {1}" -f (Get-Date -Format "HH:mm:ss"), $Message
    Write-Host $line
    Add-Content -Path $LogPath -Value $line -Encoding UTF8
}

function Test-Admin {
    $id = [Security.Principal.WindowsIdentity]::GetCurrent()
    (New-Object Security.Principal.WindowsPrincipal $id).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator)
}

function Get-TargetDevices {
    Get-PnpDevice -PresentOnly -ErrorAction SilentlyContinue |
        Where-Object { $_.InstanceId -like "USB\VID_$VendorId*" }
}

function Get-DeviceProp {
    param($Device, [string]$Key)
    try { (Get-PnpDeviceProperty -InstanceId $Device.InstanceId -KeyName $Key -ErrorAction Stop).Data }
    catch { $null }
}

function Show-Devices {
    param([string]$Title)
    $devs = @(Get-TargetDevices)
    Log "---- $Title ----"
    if ($devs.Count -eq 0) {
        Log "No VID_$VendorId device is connected right now."
        return $devs
    }
    foreach ($d in $devs) {
        $inf = Get-DeviceProp $d "DEVPKEY_Device_DriverInfPath"
        $hw  = Get-DeviceProp $d "DEVPKEY_Device_HardwareIds"
        $cp  = Get-DeviceProp $d "DEVPKEY_Device_CompatibleIds"
        Log ("Device : {0}  [{1}]" -f $d.FriendlyName, $d.Status)
        Log ("  Instance   : {0}" -f $d.InstanceId)
        Log ("  Driver INF : {0}" -f ($(if ($inf) { $inf } else { "(none)" })))
        Log ("  HardwareIds: {0}" -f ($hw -join ", "))
        Log ("  CompatIds  : {0}" -f ($cp -join ", "))
        if ($inf -like "usbmidi2*") {
            Log "  >> Bound to the Windows MIDI 2 driver. Firmware updaters cannot use this."
        } elseif ($inf -like "wdma_usb*") {
            Log "  >> Bound to the USB Audio class driver. This is what the updater needs."
        }
    }
    return $devs
}

# ------------------------------------------------------------------ start ----
"" | Out-File $LogPath -Encoding UTF8
Log "Hotone-family firmware driver fix  (vendor 84EF: Valeton / Hotone / Sonicake)"
Log ("Windows {0}  build {1}" -f (Get-CimInstance Win32_OperatingSystem).Caption, [Environment]::OSVersion.Version.Build)
Log ("Mode: {0}" -f ($(if ($Diagnose) { "DIAGNOSE (no changes)" } else { "FIX" })))

$before = Show-Devices "Devices BEFORE"

if ($Diagnose) {
    Log "Diagnose mode - nothing was changed."
    Start-Process notepad.exe $LogPath
    return
}

if (-not (Test-Admin)) {
    Log "Administrator rights are required to change drivers. Re-launching elevated..."
    $argList = "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`" -VendorId $VendorId -LogDir `"$LogDir`""
    Start-Process powershell.exe -Verb RunAs -ArgumentList $argList
    return
}

if (-not (Test-Path $Inf)) {
    Log "ERROR: $Inf not found. This Windows build has no in-box USB Audio class driver."
    Start-Process notepad.exe $LogPath
    return
}

if ($before.Count -eq 0) {
    Log "Nothing to fix: no Valeton / Hotone / Sonicake device is connected."
    Log "Connect the pedal by USB (normal mode if the Suite does not see it; on the"
    Log "'Firmware Update / Restore' screen if the update stops at 0%), then run again."
    Start-Process notepad.exe $LogPath
    return
}

# Remove any leftover device-install policies that could block the driver swap.
Remove-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Device Installer" `
    -Name DisableCoInstallers -ErrorAction SilentlyContinue
Remove-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeviceInstall\Settings" `
    -Recurse -ErrorAction SilentlyContinue

Add-Type -TypeDefinition @"
using System;
using System.Runtime.InteropServices;
public static class NewDev {
    [DllImport("newdev.dll", SetLastError = true, CharSet = CharSet.Unicode)]
    public static extern bool UpdateDriverForPlugAndPlayDevices(
        IntPtr hwnd, string hardwareId, string infPath, uint flags, out bool reboot);
}
"@

$INSTALLFLAG_FORCE = 1
$ids = @()
foreach ($d in $before) {
    $ids += Get-DeviceProp $d "DEVPKEY_Device_HardwareIds"
    $ids += Get-DeviceProp $d "DEVPKEY_Device_CompatibleIds"
}
# The USB Audio class INF matches on these class IDs; try them last as a fallback.
$ids += "USB\Class_01&SubClass_03", "USB\Class_01&SubClass_01", "USB\Class_01"
$ids  = $ids | Where-Object { $_ } | Select-Object -Unique

Log "---- Applying USB Audio class driver ($Inf) ----"
$anyOk = $false
$needReboot = $false
foreach ($id in $ids) {
    $reboot = $false
    $ok  = [NewDev]::UpdateDriverForPlugAndPlayDevices([IntPtr]::Zero, $id, $Inf, $INSTALLFLAG_FORCE, [ref]$reboot)
    $err = [Runtime.InteropServices.Marshal]::GetLastWin32Error()
    if ($ok) { $anyOk = $true; if ($reboot) { $needReboot = $true } }
    # 259 = ERROR_NO_MORE_ITEMS: no device with that ID matched the INF (expected for most IDs)
    $note = if ($ok) { "applied" } elseif ($err -eq 259) { "no match" } else { "error $err" }
    Log ("  {0,-55} {1}" -f $id, $note)
}

$after = Show-Devices "Devices AFTER"
$fixed = @($after | Where-Object { (Get-DeviceProp $_ "DEVPKEY_Device_DriverInfPath") -like "wdma_usb*" })

Log "---- Result ----"
if ($fixed.Count -gt 0) {
    Log ("SUCCESS: {0} device(s) now use the USB Audio class driver." -f $fixed.Count)
    Log "Now open the Valeton Suite / Hotone app: it should see the pedal, or run the firmware update."
    Log "REMINDER: normal mode and update mode are different devices. If you fixed the"
    Log "connection now and the update later stops at 0%, run this again with the pedal"
    Log "on its 'Firmware Update / Restore' screen."
    if ($needReboot) { Log "Windows asked for a reboot. Try the update first; reboot only if it still fails." }
} elseif ($anyOk) {
    Log "The driver was applied but the device did not report wdma_usb.inf yet."
    Log "Unplug and re-plug the USB cable, or reboot, then run the update."
} else {
    Log "FAILED: no driver could be applied. Please open an issue and attach this log."
}
Start-Process notepad.exe $LogPath
