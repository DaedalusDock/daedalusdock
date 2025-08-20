@echo off
SET SCRIPT=%~dp0src\typeinfo_converter.py

IF "%~1"=="" (
    echo Please drag and drop a config file onto this script.
    pause
    exit /b 1
)

call "%~dp0\..\bootstrap\python" "%SCRIPT%" %*
pause
