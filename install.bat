@echo off
setlocal enabledelayedexpansion

:: Define variables
set "URL=https://drive.usercontent.google.com/download?id=1lWeWqq45fbLB6h2aIMZj97Ktw2KoLi8k&export=download&authuser=0&confirm=t&uuid=94b2236e-1455-49b5-a60f-6cb3387420a5&at=AEz70l6fca_1D5nlfRxBLS0K9H8M%3A1742546677389"
set "FILENAME=PacketTracer.exe"
set "LOGFILE=%TEMP%\PacketTracer_Install.log"

:: Change to the temp directory
cd /d %TEMP%

:: Download Packet Tracer using curl; if curl fails, try bitsadmin
echo Downloading Packet Tracer...
curl -o %FILENAME% "%URL%" --silent --show-error || (
    echo Curl failed, attempting download with bitsadmin...
    bitsadmin /transfer "PacketTracerDownload" /download /priority normal "%URL%" %FILENAME%
)

:: Verify that the file was downloaded
if not exist %FILENAME% (
    echo Download failed! Exiting...
    exit /b 1
)

:: Execute the installer silently
echo Installing Packet Tracer...
start /wait %FILENAME% /quiet /norestart /log "%LOGFILE%"

:: Check if the installation was successful
if %ERRORLEVEL% NEQ 0 (
    echo Installation failed! Check log file at: %LOGFILE%
    exit /b 1
)

:: Cleanup: remove the installer file
del %FILENAME%
echo Installation completed successfully!

endlocal
exit /b 0
