@echo off
setlocal EnableExtensions EnableDelayedExpansion
title 2d2 v4.0.0 - Setup

set "ROOT=%~dp0"
set "PY_VERSION=3.13.16"
set "PY_URL=https://www.python.org/ftp/python/3.13.16/python-3.13.16-amd64.exe"
set "PY_SHA256=fb4f9f5d438b2396da0086dc70b935c530cb578e37adc6d354f7ad2037fee83b"
set "PY_INSTALLER=%TEMP%\2d2_python_%PY_VERSION%.exe"

echo.
echo ==========================================
echo           2d2 v4.0.0 Setup
echo ==========================================
echo.

REM ==========================================================
REM 1. Python 3.13
REM ==========================================================

py -3.13 --version >nul 2>&1

if not errorlevel 1 (
    call :RED "[FAILURE] Python 3.13 is already downloaded."
) else (
    call :CYAN "[INFO] Python 3.13 is not installed."
    echo [INFO] Downloading Python %PY_VERSION%...
    echo.

    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
      "$ProgressPreference='SilentlyContinue'; Invoke-WebRequest -Uri '%PY_URL%' -OutFile '%PY_INSTALLER%'"

    if not exist "%PY_INSTALLER%" (
        call :RED "[FAILURE] Python download failed."
    ) else (
        echo [INFO] Verifying Python installer...

        for /f "usebackq delims=" %%H in (`powershell -NoProfile -Command "(Get-FileHash -Algorithm SHA256 '%PY_INSTALLER%').Hash.ToLower()"`) do (
            set "ACTUAL_SHA=%%H"
        )

        if /I not "%ACTUAL_SHA%"=="%PY_SHA256%" (
            call :RED "[FAILURE] Python installer SHA-256 verification failed."
            del /q "%PY_INSTALLER%" >nul 2>&1
        ) else (
            echo [INFO] Installing Python %PY_VERSION%...

            "%PY_INSTALLER%" /quiet InstallAllUsers=0 PrependPath=1 Include_pip=1 Include_test=0

            if errorlevel 1 (
                call :RED "[FAILURE] Python installation failed."
            ) else (
                call :GREEN "[SUCCESS] Python %PY_VERSION% installed."
            )

            del /q "%PY_INSTALLER%" >nul 2>&1
        )
    )
)

echo.

REM ==========================================================
REM 2. pip
REM ==========================================================

py -3.13 -m pip --version >nul 2>&1

if not errorlevel 1 (
    call :RED "[FAILURE] pip is already downloaded."
) else (
    call :CYAN "[INFO] pip is not installed."
    echo [INFO] Installing pip...

    py -3.13 -m ensurepip --upgrade >nul 2>&1

    if errorlevel 1 (
        call :RED "[FAILURE] pip installation failed."
    ) else (
        call :GREEN "[SUCCESS] pip installed."
    )
)

echo.

REM ==========================================================
REM 3. CustomTkinter
REM ==========================================================

py -3.13 -c "import customtkinter" >nul 2>&1

if not errorlevel 1 (
    call :RED "[FAILURE] customtkinter is already downloaded."
) else (
    call :CYAN "[INFO] customtkinter is not installed."
    echo [INFO] Downloading customtkinter...

    py -3.13 -m pip install customtkinter

    if errorlevel 1 (
        call :RED "[FAILURE] customtkinter download failed."
    ) else (
        call :GREEN "[SUCCESS] customtkinter installed."
    )
)

echo.

REM ==========================================================
REM 4. discord.py
REM ==========================================================

py -3.13 -c "import discord" >nul 2>&1

if not errorlevel 1 (
    call :RED "[FAILURE] discord.py is already downloaded."
) else (
    call :CYAN "[INFO] discord.py is not installed."
    echo [INFO] Downloading discord.py...

    py -3.13 -m pip install discord.py

    if errorlevel 1 (
        call :RED "[FAILURE] discord.py download failed."
    ) else (
        call :GREEN "[SUCCESS] discord.py installed."
    )
)

echo.

REM ==========================================================
REM 5. Pillow
REM ==========================================================

py -3.13 -c "from PIL import Image" >nul 2>&1

if not errorlevel 1 (
    call :RED "[FAILURE] Pillow is already downloaded."
) else (
    call :CYAN "[INFO] Pillow is not installed."
    echo [INFO] Downloading Pillow...

    py -3.13 -m pip install Pillow

    if errorlevel 1 (
        call :RED "[FAILURE] Pillow download failed."
    ) else (
        call :GREEN "[SUCCESS] Pillow installed."
    )
)

echo.

REM ==========================================================
REM 6. PyInstaller
REM ==========================================================

py -3.13 -m PyInstaller --version >nul 2>&1

if not errorlevel 1 (
    call :RED "[FAILURE] PyInstaller is already downloaded."
) else (
    call :CYAN "[INFO] PyInstaller is not installed."
    echo [INFO] Downloading PyInstaller...

    py -3.13 -m pip install pyinstaller

    if errorlevel 1 (
        call :RED "[FAILURE] PyInstaller download failed."
    ) else (
        call :GREEN "[SUCCESS] PyInstaller installed."
    )
)


REM ==========================================================
REM Complete
REM ==========================================================

echo ==========================================
echo           Setup Complete
echo ==========================================
echo.

call :GREEN "[SUCCESS] All checks have been completed."

echo.
pause
exit /b 0

REM ==========================================================
REM Colored Output
REM ==========================================================

:RED
powershell -NoProfile -Command "Write-Host '%~1' -ForegroundColor Red"
exit /b 0

:GREEN
powershell -NoProfile -Command "Write-Host '%~1' -ForegroundColor Green"
exit /b 0

:CYAN
powershell -NoProfile -Command "Write-Host '%~1' -ForegroundColor Cyan"
exit /b 0