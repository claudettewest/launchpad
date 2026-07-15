@echo off
setlocal

cd /d "%~dp0"

where node >nul 2>&1
if errorlevel 1 (
  echo Node.js is required but was not found in PATH.
  echo Install Node.js, then run this script again.
  pause
  exit /b 1
)

netsh advfirewall firewall show rule name="LandingPage-3411" >nul 2>&1
if errorlevel 1 (
  echo Requesting administrator permission to allow remote access on TCP port 3411...
  powershell -NoProfile -Command "Start-Process -FilePath 'netsh.exe' -Verb RunAs -Wait -ArgumentList 'advfirewall','firewall','add','rule','name=LandingPage-3411','dir=in','action=allow','protocol=TCP','localip=100.127.36.5','remoteip=100.64.0.0/10','localport=3411','profile=any'"
  netsh advfirewall firewall show rule name="LandingPage-3411" >nul 2>&1
  if errorlevel 1 (
    echo The firewall rule was not added. Remote access may remain blocked.
    pause
    exit /b 1
  )
)

set "HOST=0.0.0.0"
set "PORT=3411"
set "PUBLIC_URL=http://100.127.36.5:3411"

echo Starting the server at %PUBLIC_URL%
start "" powershell -NoProfile -WindowStyle Hidden -Command "$url='%PUBLIC_URL%'; for ($i=0; $i -lt 20; $i++) { try { Invoke-WebRequest -UseBasicParsing -Uri $url -TimeoutSec 1 ^| Out-Null; Start-Process $url; exit } catch { Start-Sleep -Milliseconds 500 } }"
node server.js

if errorlevel 1 (
  echo.
  echo The server stopped because of an error.
  pause
  exit /b 1
)
