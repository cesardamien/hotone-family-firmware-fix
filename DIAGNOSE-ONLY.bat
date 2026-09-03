@echo off
:: Shows which driver each connected Valeton / Hotone / Sonicake device uses.
:: Changes nothing. No administrator prompt.
call "%~dp0FIX-FIRMWARE-DRIVER.bat" -Diagnose
