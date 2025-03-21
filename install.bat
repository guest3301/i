@echo off
setlocal enabledelayedexpansion

:: Set download parameters
set "URL=https://drive.usercontent.google.com/download?id=1lWeWqq45fbLB6h2aIMZj97Ktw2KoLi8k&export=download&authuser=0&confirm=t&uuid=94b2236e-1455-49b5-a60f-6cb3387420a5&at=AEz70l6fca_1D5nlfRxBLS0K9H8M%3A1742546677389"
set "FILENAME=PacketTracer.exe"
set "FILEPATH=%USERPROFILE%\Desktop\%FILENAME%"
set "LOGFILE=%TEMP%\PacketTracer_Install.log"

:: Download using BITSAdmin (works on both Win7/10)
echo Downloading Cisco Packet Tracer...
bitsadmin /transfer "PacketTracerDownload" /download /priority normal "%URL%" "%FILEPATH%"

:: If BITS fails, try PowerShell (for newer systems)
if not exist "%FILEPATH%" (
    echo Trying PowerShell download method...
    powershell -Command "[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; (New-Object Net.WebClient).DownloadFile('%URL%', '%FILEPATH%')"
)

:: Verify download
if not exist "%FILEPATH%" (
    echo Failed to download file
    exit /b 1
) else (
    echo Successfully downloaded: %FILEPATH%
)

:: Attempt silent installation
echo Attempting silent installation...
start "" /wait "%FILEPATH%" /S /v"/qn /l*v %LOGFILE%"

:: Check installation result
if %ERRORLEVEL% EQU 0 (
    echo Silent installation completed successfully.
) else (
    echo Silent installation failed (Error: %ERRORLEVEL%). Starting interactive installer...
    start "" "%FILEPATH%"
)

endlocal
exit /b %ERRORLEVEL%
