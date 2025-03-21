@echo off
setlocal enabledelayedexpansion

:: Define variables
set "URL=https://drive.usercontent.google.com/download?id=1lWeWqq45fbLB6h2aIMZj97Ktw2KoLi8k&export=download&authuser=0&confirm=t&uuid=94b2236e-1455-49b5-a60f-6cb3387420a5&at=AEz70l6fca_1D5nlfRxBLS0K9H8M%3A1742546677389"
set "FILENAME=PacketTracer.exe"
set "FILEPATH=%USERPROFILE%\Desktop\%FILENAME%"
set "LOGFILE=%TEMP%\PacketTracer_Install.log"

:: Change to the Desktop directory
cd /d "%USERPROFILE%\Desktop"

:: Download Packet Tracer using curl; if curl fails, try bitsadmin
echo Downloading Packet Tracer to Desktop...
curl -o "%FILENAME%" "%URL%" --silent --show-error || (
    echo Curl failed, attempting download with bitsadmin...
    bitsadmin /transfer "PacketTracerDownload" /download /priority normal "%URL%" "%FILEPATH%"
)

:: Verify that the file was downloaded
if not exist "%FILEPATH%" (
    echo Download failed! Exiting...
    exit /b 1
)

:: Attempt silent installation
echo Attempting silent installation...
start /wait "" "%FILEPATH%" /quiet /norestart /log "%LOGFILE%"

:: Check if silent installation succeeded
if %ERRORLEVEL% NEQ 0 (
    echo Silent installation failed. Launching interactive installer...
    start "" "%FILEPATH%"
) else (
    echo Silent installation completed successfully.
)

endlocal
exit /b 0
