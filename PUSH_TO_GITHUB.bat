@echo off
title Push Team 17 CA3 to GitHub
setlocal

set "PATH=%LOCALAPPDATA%\Programs\git\cmd;%LOCALAPPDATA%\Microsoft\WinGet\Packages\GitHub.cli_Microsoft.Winget.Source_8wekyb3d8bbwe\bin;%PATH%"

cd /d "%~dp0"

echo ============================================================
echo        PUSH TEAM 17 CA3 PROJECT TO GITHUB
echo ============================================================
echo.

git status >nul 2>&1
if %errorlevel% neq 0 (
    echo [INFO] Initializing Git repository...
    git init -b main
    git config user.name "Team 17"
    git config user.email "team17@apextech.com"
)

echo [INFO] Staging all files...
git add .

git status --porcelain | findstr /R ".*" >nul 2>&1
if %errorlevel% equ 0 (
    echo [INFO] Committing changes...
    git commit -m "Update: Team 17 CA3 E-Commerce and Selenium Automation"
) else (
    echo [INFO] Working tree is clean. Everything is committed.
)

:: Check if remote origin exists
git remote get-url origin >nul 2>&1
if %errorlevel% neq 0 (
    echo.
    echo ------------------------------------------------------------
    echo No GitHub remote URL found for this repository.
    echo ------------------------------------------------------------
    echo Please enter your GitHub repository URL:
    echo (Example: https://github.com/your-username/apextech-store.git)
    echo.
    set /p REPO_URL="GitHub URL: "
    if "%REPO_URL%"=="" (
        echo [ERROR] No URL provided. Aborting push.
        pause
        exit /b 1
    )
    git remote add origin %REPO_URL%
)

echo.
echo [INFO] Pushing main branch to GitHub...
git branch -M main
git push -u origin main

if %errorlevel% equ 0 (
    echo.
    echo ============================================================
    echo [SUCCESS] Code successfully pushed to GitHub!
    echo ============================================================
) else (
    echo.
    echo [ERROR] Push failed. Please check your GitHub permissions or credentials.
)

pause
