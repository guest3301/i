@echo off
setlocal

:: Define variables
set "URL=https://drive.usercontent.google.com/download?id=1lWeWqq45fbLB6h2aIMZj97Ktw2KoLi8k&export=download"
set "FILENAME=%USERPROFILE%\Desktop\PacketTracer.exe"

:: Download Packet Tracer
curl -o "%FILENAME%" "%URL%" --silent --show-error || bitsadmin /transfer "PacketTracerDownload" /download /priority normal "%URL%" "%FILENAME%"

:: Verify download
if not exist "%FILENAME%" (
    echo Download failed!
    exit /b 1
)

:: Execute Packet Tracer installer
start "" "%FILENAME%"

endlocal
