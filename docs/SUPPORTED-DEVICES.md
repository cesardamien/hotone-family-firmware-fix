# Supported devices

Every product below shares USB vendor ID `84EF` (Hotone Audio, the company behind the Valeton, Hotone and Sonicake brands). The script targets the vendor ID, not a model list, so any device in this family — including models released after this page was written — is covered automatically.

**Status legend:** ✅ confirmed by a user log · 🟡 same hardware family, expected to work, not yet confirmed · ➕ please report

The PID shown is the **normal-mode** Product ID (what Device Manager shows when the pedal is just plugged in). The firmware-update / bootloader mode uses a *different* PID — on the GP-180 it is the normal PID + 1 (`0188` → `0189`). If you can confirm the bootloader PID for your model from the log, please open an issue so it can be added here.

## Valeton

| Model | Normal PID | Bootloader PID | Status |
|---|---|---|---|
| GP-180 | `0188` | `0189` | ✅ confirmed (V1.0.0 → V1.1.1, Windows 11 25H2 build 26200, Sept 2026) |
| GP-5 | `0184` | ➕ | 🟡 |
| GP-50 | `018A` | ➕ | 🟡 |
| GP-100 | `0021` | ➕ | 🟡 — the model Valeton's own Win11 notice was written for |
| GP-150 | `0186` | ➕ | 🟡 |
| GP-200 | `002A` | ➕ | 🟡 — same failure reported in [microsoft/MIDI #944](https://github.com/microsoft/MIDI/issues/944) |
| GP-200JR | `0180` | ➕ | 🟡 |
| GP-200LT | `002C` | ➕ | 🟡 |
| GP-300 | `018C` | ➕ | 🟡 |

## Hotone

| Model | Normal PID | Bootloader PID | Status |
|---|---|---|---|
| Ampero (MP-100) | `0012` | ➕ | 🟡 |
| Ampero One (MP-80) | `001F` | ➕ | 🟡 |
| Ampero Mini | `0080` | ➕ | 🟡 |
| Ampero II (MP-300 family) | `0050` | ➕ | 🟡 |
| Ampero II Stomp | `0030` | ➕ | 🟡 |
| Ampero II Stage / II XL | `0052` | ➕ | 🟡 |
| Pulze | `002E` | ➕ | 🟡 |
| Pulze Mini | `0082` | ➕ | 🟡 |
| Jogg | `0014` | ➕ | 🟡 |
| UA-12 | `0032` | ➕ | 🟡 |
| GP-100 (Hotone-branded) | `0055` | ➕ | 🟡 |

## Sonicake

| Model | Normal PID | Bootloader PID | Status |
|---|---|---|---|
| Matribox | `0054` | ➕ | 🟡 |
| Matribox II | `0280` | ➕ | 🟡 |
| Matribox II Pro | `0282` | ➕ | 🟡 |
| Pocket Master | `0284` | ➕ | 🟡 |
| Smart Box | `0286` | ➕ | 🟡 |
| Sonic Cube | `0038` | ➕ | 🟡 |
| Sonic Cube II | `028A` / `028C` | ➕ | 🟡 |
| AMPCUBE | `0290` | ➕ | 🟡 |

PID list compiled from public Windows driver databases ([Treexy VID_84EF](https://treexy.com/products/driver-fusion/database/id/usb/vid_84ef/)); model naming follows the vendor INF strings. Corrections welcome.

## Why the whole family is affected

All of these devices update firmware the same way: the pedal reboots into a bootloader that exposes a single USB-MIDI interface, and the desktop updater streams the firmware as MIDI SysEx. Anything Windows does to USB-MIDI devices in general — such as binding the new `usbmidi2.sys` driver from Windows MIDI Services — hits every one of them identically. Both Valeton and Hotone published the same Windows 11 notice for that reason.

## Not affected

- **macOS** and **Linux** — no driver conflict exists there.
- **Windows 10** — Windows MIDI Services is Windows 11 only.
- **Windows 11 before February 2026 updates** — the old driver is still the default.
