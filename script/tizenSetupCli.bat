:: Hide Command and Set Scope
@echo off
setlocal EnableExtensions

:: Menu Options
:: Specify as many as you want, but they must be sequential from 1 with no gaps
:: Step 1. List the Application Names
set "TIZEN_PATH=C:\tizen-studio\ide"
set "TIZEN_SDK_PATH=C:\tizen-studio"
set "PATH_SECURITY_PROFILES=C:\tizen-studio-data\profile\profiles.xml"
set "PATH_TIZEN_CLI=c:\tizen-studio\tools\ide\bin"

:Check
:: check for admin rights
echo Administrative permissions required. Detecting permissions...
 net session >nul 2>&1
    if %errorLevel% == 0 (
        echo Success: Administrative permissions confirmed.
        goto Menu
    ) else (
        echo Failure: Current permissions inadequate.
        goto :EOF
    )

    pause >nul


:: Display the Menu
:Menu
cls
echo. 1) Install
echo. 2) Update 
echo. 3) Generate Signed Tizen Widget
echo. 4) Quit
echo.
echo. Please choose the option
echo.
choice /C 1234 /N /M "->"
goto option-%errorlevel%

:: Run Installations
:: Specify all of the installations for each app.
:: Step 2. Match on the application names and perform the installation for each
:option-1 Install
    echo Run Install Tizen Studio
    echo %%path|find "TIZEN_PATH" > nul
    if errorlevel 1 (
        echo "Adding to the path..."
        setx /M PATH "%PATH%;%TIZEN_PATH%"
    )

    curl http://download.tizen.org/sdk/Installer/tizen-studio_4.1/web-cli_Tizen_Studio_4.1_windows-64.exe? -O
    ren web-cli_Tizen_Studio_4.1_windows-64.exe_ web-cli_Tizen_Studio_4.1_windows-64.exe
    echo "Please install in the default path: %TIZEN_PATH%"
    START /wait web-cli_Tizen_Studio_4.1_windows-64.exe --accept-license
    echo Installing 3 additional packages. Please be patient...
    cd /D %TIZEN_SDK_PATH%\package-manager
    START /wait package-manager-cli.exe install cert-add-on --accept-license
    echo Installed 1/3
    START /wait package-manager-cli.exe install TV-SAMSUNG-Extension-Tools --accept-licens
    echo Installed 2/3
    START /wait package-manager-cli.exe install TV-SAMSUNG-Public --accept-license
    echo Installed 3/3  
    
    cd %TIZEN_PATH%
    START TizenStudio.exe
    exit 0

:option-2 Update
    echo Updating... Please be patient...
    cd /D %TIZEN_SDK_PATH%\package-manager
    START /wait package-manager-cli.exe update --accept-license --latest
    echo Updated

    cd %TIZEN_PATH%
    START TizenStudio.exe
    exit 0

:option-3 Widgets
    echo Generate signed Tizen Widget

    cd /D %PATH_TIZEN_CLI%
    CALL tizen security-profiles list > temp.txt
    set "FOUND="

    for /f "delims=" %%i in (%PATH_SECURITY_PROFILES%) do (
        echo."%%i"
        echo."%%i"| FIND /I "profileitem">Nul && (
            set "FOUND=Y"
        )
    )

    for /f "delims=" %%i in (temp.txt) do (
        echo."%%i"
        echo."%%i"| FIND /I "not found">Nul && (
            set "FOUND="
        )
    )
    DEL /Q temp.txt

    if not defined FOUND (
        echo.
        echo.
        echo No security profile found, open Tizen Certificate Manager to create certificate profile.
        exit 0
    )

    echo Found profile
    set /p "profile=Enter security profile name:"
    echo profile is %profile%

    set "buildPath="
    set /p "buildPath=Path to your application's Tizen folder:"
    echo buildPath is %buildPath%

    CALL tizen package -t wgt -s %profile% -- %buildPath% > temp.txt
    for /f "delims=" %%i in (temp.txt) do (
        echo."%%i"
    )
    DEL /Q temp.txt

    pause >nul
    exit 0

:option-4 Exit
echo. Finished...
endlocal
