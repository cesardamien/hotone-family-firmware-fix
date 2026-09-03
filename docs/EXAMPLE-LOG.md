# Example log — Valeton GP-180, Windows 11, 3 Sept 2026

This is the real output from the first-generation script run on the GP-180 that started this project. The pedal was on the *Firmware Update / Restore* screen the whole time. Serial numbers are redacted; nothing else was edited.

Read it top to bottom and notice three things:

1. **Three devices, not one.** The normal-mode pedal (`PID_0188`, plus its MIDI sub-interface `MI_03`) is still registered from earlier sessions but reports `Unknown` — it is not physically present. The bootloader device (`PID_0189`) is the one that is `OK`.
2. **Before:** `PID_0189` is bound to `usbmidi2.inf` — Windows' new MIDI 2 driver. That is why the updater died at 0 %.
3. **After:** `PID_0189` is bound to `wdma_usb.inf` — the USB Audio class driver. The updater then ran to 100 % on the first try, followed by the second "BT And PD" stage.

```
Inicio 09/03/2026 15:42:56
Registro revertido
DEV: Valeton GP-180 | USB\VID_84EF&PID_0188\XXXXXXXX | Unknown
  HW: USB\VID_84EF&PID_0188&REV_0101, USB\VID_84EF&PID_0188
  CP: USB\COMPAT_VID_84EF&DevClass_00&SubClass_00&Prot00, ..., USB\COMPOSITE
  INF atual: oem113.inf                     <- vendor ASIO driver (normal mode, not present)
DEV: Valeton GP-180 Subdevice | USB\VID_84EF&PID_0188&REV_0101&MI_03\XXXXXXXX | Unknown
  HW: USB\VID_84EF&PID_0188&REV_0101&MI_03, USB\VID_84EF&PID_0188&MI_03
  CP: USB\CLASS_01&SUBCLASS_03&PROT_00, USB\CLASS_01&SUBCLASS_03, USB\CLASS_01
  INF atual: usbmidi2.inf
DEV: GP-180 | USB\VID_84EF&PID_0189\V1.0.0 | OK        <- THE BOOTLOADER DEVICE
  HW: USB\VID_84EF&PID_0189&REV_0100, USB\VID_84EF&PID_0189
  CP: USB\COMPAT_VID_84EF&Class_01&SubClass_03&Prot_00, ..., USB\Class_01&SubClass_03, USB\Class_01
  INF atual: usbmidi2.inf                   <- the problem
UPDATE USB\VID_84EF&PID_0188&REV_0101 -> ok=False err=259     (259 = no present device with this ID)
UPDATE USB\VID_84EF&PID_0188 -> ok=False err=259
...
UPDATE USB\CLASS_01&SUBCLASS_03&PROT_00 -> ok=True err=0
UPDATE USB\CLASS_01&SUBCLASS_03 -> ok=True err=0
UPDATE USB\VID_84EF&PID_0189&REV_0100 -> ok=True err=0        <- driver forced onto the bootloader device
UPDATE USB\VID_84EF&PID_0189 -> ok=True err=0
UPDATE USB\Class_01&SubClass_01 -> ok=True err=0
--- DEPOIS ---
Valeton GP-180 | Unknown | INF: oem113.inf
Valeton GP-180 Subdevice | Unknown | INF: usbmidi2.inf
GP-180 | OK | INF: wdma_usb.inf              <- fixed
Fim
```

Timeline after the fix: Valeton Suite → *Firmware Update* → `GP-180 Firmware V1.1.1.bin` → 1 % within 3 seconds → 100 % in about 4 minutes → "BT And PD Updating" stage → pedal rebooted itself into normal mode → Suite reconnected in *Editing* mode.

The bootloader's `V1.0.0` in the instance path is the firmware version the pedal was running before the update.
