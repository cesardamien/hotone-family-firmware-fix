# How it works (technical notes)

For readers who want the mechanism rather than the story. The user-facing explanation is in the README.

## The three layers of the failure

As experienced by the GP-180 that started this project: (a) fresh pedal on V1.0.0 was not detected by Valeton Suite at all — no NAM/IR transfer, no way to start an update; (b) the official driver swap on the normal-mode instance restored the connection; (c) the firmware update then froze at 0% and the pedal stayed on the update screen, because the bootloader instance is a separate device with its own (wrong) binding. Mechanically:

1. **Driver ranking change.** Windows MIDI Services (Windows 11, February 2026) ships `usbmidi2.inf` / `usbmidi2.sys`, an in-box class driver for `USB\Class_01&SubClass_03` (Audio class, MIDI Streaming subclass). It outranks the legacy `wdma_usb.inf` / `usbaudio.sys` for the same compatible ID, so new USB-MIDI device instances are bound to it. The Valeton/Hotone updaters open the legacy MIDI endpoint and stream the firmware as SysEx; through `usbmidi2` the transfer never starts.

2. **Different device instance in bootloader mode.** Hotone-family pedals re-enumerate with a different Product ID when they enter firmware-update mode (GP-180: `PID_0188` normal, `PID_0189` bootloader). PnP treats it as a new device with its own driver binding. Changing the driver on the normal-mode instance has no effect on the bootloader instance.

3. **Compatible-driver list filtering.** Device Manager's "Let me pick" dialog with *Show compatible hardware* checked lists drivers by rank for the instance's IDs; on affected builds `wdma_usb.inf` is frequently absent for the bootloader instance. Unchecking the box or using *Have Disk…* works, but is error-prone for non-technical users.

## What the script does

- Enumerates present devices with `Get-PnpDevice -PresentOnly` filtered to `USB\VID_84EF*`, and logs FriendlyName, InstanceId, Status, `DEVPKEY_Device_DriverInfPath`, `DEVPKEY_Device_HardwareIds`, `DEVPKEY_Device_CompatibleIds`.
- Removes `HKLM\...\Device Installer\DisableCoInstallers` and the `HKLM\SOFTWARE\Policies\...\DeviceInstall\Settings` key if present (a policy that would deny the install).
- P/Invokes `newdev.dll!UpdateDriverForPlugAndPlayDevicesW(NULL, hardwareId, "%WINDIR%\INF\wdma_usb.inf", INSTALLFLAG_FORCE, &reboot)` for each hardware ID and compatible ID of the present devices, then for the generic class IDs `USB\Class_01&SubClass_03`, `USB\Class_01&SubClass_01`, `USB\Class_01`. This is the API behind *Have Disk…*; `INSTALLFLAG_FORCE` allows a lower-ranked INF. `ERROR_NO_MORE_ITEMS` (259) means no present device matched that ID and is expected for most IDs.
- Re-enumerates and reports success when at least one present `VID_84EF` instance reports `wdma_usb.inf`.
- Because it targets whatever `VID_84EF` instances are *present*, the same run fixes the normal-mode MIDI sub-interface (`MI_03`, the connection / NAM-IR problem) or the bootloader instance (the 0% problem), depending on which state the pedal is in. The composite parent (`USB\COMPOSITE`) does not match `wdma_usb.inf` and is left alone, so the vendor ASIO driver on the parent survives.

The all-in-one `.bat` is a polyglot: the batch header extracts everything after the `#__POWERSHELL_STARTS_HERE__` marker into `%TEMP%` and runs it with `-ExecutionPolicy Bypass`, passing the `.bat`'s folder as `-LogDir`. The script self-elevates with `Start-Process -Verb RunAs` when not already administrator. `source/Fix-FirmwareDriver.ps1` is the identical script as a plain file.

## Why not…

- **Disable/uninstall `usbmidi2`?** It is an in-box driver package; `pnputil /delete-driver` refuses, and disabling the service leaves the device unstartable rather than falling back.
- **Group Policy to block the MIDI driver?** Device-install policies match device IDs, not driver packages; they cannot express "prefer INF A over INF B".
- **Roll back the Windows update?** The MIDI stack is carried by every later cumulative update; uninstalling one KB does not remove it.
- **Vendor ASIO driver?** The vendor INFs (e.g. `ValetonUsbAudio.inf`) list specific normal-mode PIDs only and do not match the bootloader instance.

## Reverting

Nothing needs reverting. The bootloader instance is only used during firmware transfer. To restore Windows' choice on it anyway: Device Manager → the device (pedal on the update screen) → *Update driver* → *Let me pick* → *USB MIDI 2.0 Device*.
