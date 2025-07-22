@echo off
title OpenNova Auto-Start
echo Starting OpenNova Website Services...
echo.

cd /d "%~dp0"

echo [1/3] Starting Backend Server...
start "OpenNova Backend" /min powershell -Command "cd '%~dp0backend'; mvn spring-boot:run -Dserver.port=8081"

echo [2/3] Waiting for backend to start...
timeout /t 45 /nobreak >nul

echo [3/3] Starting Frontend Server...
cd "%~dp0netlify-fix"
echo.
echo ========================================
echo 🎉 OpenNova Website is now running!
echo 📱 Phone URL: http://192.168.182.95:8000
echo ========================================
echo.
python -m http.server 8000 