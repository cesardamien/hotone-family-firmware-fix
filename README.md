# Valeton / Hotone / Sonicake pedal not connecting to the PC — or firmware update stuck at 0% — on Windows 11?

[🇧🇷 Português](README.pt-BR.md) · **Valeton · Hotone · Sonicake · Windows 11**

<p align="center"><b>Download one file. Double-click it. Click "Yes". Try again.</b></p>

![Firmware update stuck at 0% on Windows 11 — one-click fix for Valeton, Hotone and Sonicake pedals](social-preview.png)

**This is you if any of these is happening:**

- The pedal is brand new (or just plugged into a new PC) and **Valeton Suite / the Hotone app does not see it**. No connection, so you cannot load NAM profiles, IRs or presets, and cannot even start a firmware update.
- You got it connected, started the firmware update, and the PC **sits at 0 % and closes** while the pedal's screen says **"Firmware Update / Restore — Please don't shut down"** — and now it will not leave that screen.
- You followed the official Valeton/Hotone instructions (swap the driver to *USB Audio Device*), it fixed the connection, **but the firmware update still dies at 0 %**.

All three are the same **Windows 11** problem hitting the pedal at different moments. The pedal is not broken. Nothing is lost. The fix takes two minutes, with no driver downloads, no Windows update rollback and no second computer — and this file handles every one of those moments.

This applies to **every** pedal from Valeton (GP-5, GP-50, GP-100, GP-150, GP-180, GP-200, GP-200JR, GP-200LT, GP-300), Hotone (Ampero, Ampero One, Ampero Mini, Ampero II, II Stomp, II Stage, II XL, Pulze, Pulze Mini, Jogg, UA-12) and Sonicake (Matribox, Matribox II and II Pro, Pocket Master, Smart Box, Sonic Cube, AMPCUBE). Three brands, one factory, the same USB electronics — and they all break the same way.

---

## Fix it now

**1.** Download **[`FIX-FIRMWARE-DRIVER.bat`](https://github.com/cesardamien/hotone-family-firmware-fix/releases/latest/download/FIX-FIRMWARE-DRIVER.bat)**. Put it in any folder — Downloads is fine.

**2.** Connect the pedal by USB, in whatever state it is in right now:
- *Pedal not detected by the Suite?* Leave it in normal mode, powered on.
- *Stuck on "Firmware Update / Restore"?* Leave it on that screen. Do not restart it.
- *Update failed and the pedal went back to normal mode?* Start the update again from the Suite until the pedal shows the update screen, then leave it there.

**3.** **Double-click** `FIX-FIRMWARE-DRIVER.bat`. Windows asks *"Do you want to allow this app to make changes to your device?"* — click **Yes**. If a blue SmartScreen page appears first saying Windows protected your PC, click *More info* → *Run anyway* (that page shows for any internet download without a paid code-signing certificate).

**4.** A few seconds later a Notepad window opens with the result. Look for the word **SUCCESS** at the end. Then do what you were trying to do: open Valeton Suite and it will see the pedal; or click *Firmware Update*, pick the firmware `.bin`, and watch the bar go to 100 %.

**5.** **Important — you will run it twice.** Fixing the connection (normal mode) and fixing the firmware update (update-mode screen) are two different devices for Windows. If you fixed the connection first and the update then stops at 0 %, leave the pedal on the update screen and double-click the file again. That second run is the one nobody documents.

If Windows asks to restart, choose *Restart later* and try first. It usually works right away.

That is all. The rest of this page is for people who want to know what happened or have a question.

---

## What was wrong (no jargon)

The pedal talks to the Valeton/Hotone software through a MIDI connection over USB. Until early 2026 Windows attached the driver that software expects (the generic *USB audio* driver). In February 2026 Microsoft shipped a new MIDI system for Windows 11, and from then on Windows prefers a new *MIDI* driver for any device of this kind. The vendor software cannot talk through that new driver. That single change shows up as three layers, in the order most people hit them:

**Layer 1 — the pedal does not connect.** You plug in a new pedal, Windows attaches the new MIDI driver to it, and the Suite simply does not see it. No NAM, no IR, no presets, no update. Valeton and Hotone know about this and published a notice: swap the driver to *USB Audio Device* in Device Manager. That notice is correct — for this layer.

**Layer 2 — the firmware update stops at 0 %.** When the pedal enters update mode it *becomes a different device* for Windows — as if you had unplugged it and plugged in something nobody had ever seen. Windows attaches the new MIDI driver to this *second* device too, independently of what you did in layer 1. The updater sends the first packet, gets no answer, and gives up; the pedal stays on the update screen waiting. This is the part the official notice does not mention: the driver swap has to be done **again, while the pedal is on the update screen**. People who "already did the fix" are stuck here, certain the fix does not work.

**Layer 3 — the option is not in the list.** When you finally open Device Manager with the pedal in the right mode, *"USB Audio Device"* often **is not offered at all**, because Windows hides anything it ranks below the new driver. The official tip to keep *"Show compatible hardware"* ticked is exactly what hides it.

`FIX-FIRMWARE-DRIVER.bat` performs the right swap, on whichever device is connected at that moment, by a route that does not depend on that list: it finds any connected Valeton/Hotone/Sonicake device — normal mode or update mode — and applies the USB audio driver that already ships inside Windows, using the same Windows function Device Manager uses under the hood. It downloads nothing, installs nothing from outside, and touches no other device on your computer.

---

## Questions people always ask

**Is this safe? It is a .bat from the internet asking for administrator rights.**
Fair question. Open the file in Notepad: everything it does is written there in readable PowerShell, nothing packed or hidden. It needs administrator rights because Windows requires them for any driver change — the same prompt would appear if you did the swap by hand. It only looks at devices with vendor code `84EF` (Valeton/Hotone/Sonicake); the rest of your computer is not even listed. If you would rather look before touching anything, `DIAGNOSE-ONLY.bat` shows what is connected and which driver it uses, changes nothing, and asks for no administrator rights.

**Will I have to do this every time I update firmware?**
Probably — and twice per update if the connection breaks as well. Windows reinstalls the driver for the "update-mode device" every time, and every Microsoft update pushes it back to the MIDI driver. Keep the file. The ritual is always the same: pedal connected → double-click → try again (and, for a firmware update, repeat with the pedal on the update screen).

**Does it change anything for normal use? Playing, recording, the editor?**
No. After the update the pedal reboots and becomes the "normal device" again with its usual driver (the vendor ASIO driver or Windows' own). The USB audio driver stays on the "update-mode device", which nothing uses outside of firmware updates.

**Notepad says "No VID_84EF device is connected right now".**
Windows is not seeing any pedal at all: it is off, the cable is charge-only, or it is on a hub. Use the cable from the box, plug straight into a port on the PC, make sure the pedal is on (normal mode or the *Firmware Update / Restore* screen — either is fine) and run it again.

**It said SUCCESS but the update still stops at 0 %.**
Restart Windows, leave the pedal on the update screen, run the update again. If it still fails, switch to a USB-A port wired directly to the motherboard (back of a desktop, side of a laptop; avoid USB-C). If it persists, open an issue here with the `firmware-fix-log.txt` that sits next to the `.bat` — we will work it out together.

**The update passed 100 % and a second bar started, "BT And PD Updating".**
Normal. Some firmware packages update two chips: the main one and the Bluetooth/power one. Let it finish; the pedal reboots itself at the end.

**I am on a Mac / Linux / Windows 10.**
Then this is not your problem. The new MIDI driver exists only on Windows 11 updated from February 2026 onwards.

---

## Confirmed where, expected where

This project was born from a **Valeton GP-180** that arrived on V1.0.0, would not connect to a fully updated Windows 11 25H2 PC at all, then got stuck on the update screen for several days once the connection was fixed. Both layers were solved with this method and it ended on V1.1.1; the whole thing is documented, log included ([docs/EXAMPLE-LOG.md](docs/EXAMPLE-LOG.md)).

On the other models the fix is the same by construction: same USB vendor code, same MIDI-based update mode, same official notice from both brands. But I do **not yet have a log from each one**. If it worked on yours — or did not — open an issue with the model and the log; it takes a minute and it is what turns "expected" into "confirmed" in the [device table](docs/SUPPORTED-DEVICES.md) for the next person.

---

## Symptoms people search for

If any of these describe you, you are in the right place: *Valeton firmware update stuck at 0%* · *Valeton Suite firmware update not working Windows 11* · *GP-200 / GP-180 / GP-100 stuck on Firmware Update Restore screen* · *Valeton pedal "please don't shut down" frozen* · *Hotone Ampero firmware update fails Windows 11* · *Ampero II Stomp / Stage update stuck* · *Sonicake Matribox firmware update 0%* · *USB Audio Device not in driver list* · *Valeton driver MIDI instead of USB audio* · *Windows 11 usbmidi2 firmware update bootloader* · *Valeton GP-180 bricked after update* (it is not bricked — run the fix and update again) · *Valeton Suite does not detect pedal* · *Valeton GP-180 not connecting to PC* · *cannot load NAM files Valeton* · *Ampero not recognized Windows 11*.

Português: *atualização de firmware Valeton travada em 0%* · *pedaleira Valeton presa na tela Firmware Update Restore* · *Valeton Suite não atualiza firmware Windows 11* · *Dispositivo de Áudio USB não aparece na lista* · *Hotone Ampero atualização de firmware não funciona*.

Español: *Valeton actualización de firmware se queda en 0%* · *Hotone Ampero actualización firmware Windows 11 no funciona* · *pedalera bloqueada en Firmware Update Restore*.

---

## Files in this repository

`FIX-FIRMWARE-DRIVER.bat` is the only file you need: the whole script lives inside it. `DIAGNOSE-ONLY.bat` is optional, looks and changes nothing (must sit in the same folder as the first). `source/Fix-FirmwareDriver.ps1` is the same script as a standalone PowerShell file, for reading or running directly. `docs/` has the device list, the real example log and the technical notes on how it works.

Made by Cesar Damien, with the analysis and code developed together with Claude (Anthropic), after a brand-new GP-180 refused to connect and then spent days stuck on the update screen. Not affiliated with Valeton, Hotone, Sonicake or Microsoft. References: [Valeton notice](https://www.valeton.net/win11-technical-notice/), [Hotone notice](https://www.hotone.cl/actualizacion-de-firmware-en-windows-11/), [Sweetwater article](https://www.sweetwater.com/sweetcare/articles/valeton-gp-series-firmware-update-fix-on-windows-11/), [Windows MIDI Services announcement](https://blogs.windows.com/windowsexperience/2026/02/17/making-music-with-midi-just-got-a-real-boost-in-windows-11/), [the same problem reported to Microsoft](https://github.com/microsoft/MIDI/issues/944). MIT License — use it, copy it, improve it.
