@echo off
title ApexTech Store - Team 17 Launcher
echo ============================================================
echo       STARTING APEXTECH E-COMMERCE STORE (TEAM 17)
echo ============================================================
echo.

cd /d "%~dp0"

:: 1. Check if server is already running on port 8080
netstat -ano | findstr /R /C:":8080 .*LISTENING" >nul 2>&1
if %errorlevel% equ 0 (
    echo [INFO] ApexTech Store server is ALREADY running on port 8080!
    echo [INFO] Opening store in browser...
    start http://localhost:8080/
    goto :done
)

:: 2. Locate Java 17 binary
set "JAVA_CMD="
if exist "%LOCALAPPDATA%\Programs\jdk17\bin\java.exe" (
    set "JAVA_CMD=%LOCALAPPDATA%\Programs\jdk17\bin\java.exe"
) else (
    where java >nul 2>&1
    if %errorlevel% equ 0 (
        set "JAVA_CMD=java"
    )
)

if "%JAVA_CMD%"=="" (
    echo [ERROR] Java 17 was not found on your system!
    echo Please make sure JDK 17 is installed in %LOCALAPPDATA%\Programs\jdk17
    pause
    exit /b 1
)

:: 3. Check for compiled application JAR
set "JAR_PATH=%~dp0target\ecommerce-automation-1.0.0.jar"
if not exist "%JAR_PATH%" (
    echo [INFO] Application JAR not found. Packaging with Maven...
    if exist "%LOCALAPPDATA%\Programs\maven\bin\mvn.cmd" (
        call "%LOCALAPPDATA%\Programs\maven\bin\mvn.cmd" package -DskipTests
    ) else (
        call mvn package -DskipTests
    )
)

:: 4. Start the server in an independent Windows console window
echo [1/3] Launching Spring Boot server on port 8080...
start "ApexTech Store Server" "%JAVA_CMD%" -jar "%JAR_PATH%"

:: 5. Wait for Tomcat to spin up
echo [2/3] Waiting for server to initialize (6 seconds)...
timeout /t 6 /nobreak >nul

:: 6. Launch browser
echo [3/3] Opening Google Chrome to website...
start http://localhost:8080/

:done
echo.
echo ============================================================
echo       APEXTECH STORE IS LIVE: http://localhost:8080/
echo ============================================================
echo.
echo The server is running independently in Windows.
echo It will stay alive even when Antigravity is closed.
echo To shut down the server, simply close the "ApexTech Store Server" window.
echo.
timeout /t 4
