@echo off
REM ==============================================================================
REM Effigy REST API Startup Script
REM ==============================================================================
REM This script starts the Effigy REST API application
REM Usage: RUN_REST_API.CMD [profile] [port]
REM   profile: dev, staging, prod (default: prod)
REM   port: port number (default: 8080)
REM ==============================================================================

setlocal enabledelayedexpansion

REM Set default values
set PROFILE=prod
set PORT=8080
set JAR_FILE=media-0.0.1-SNAPSHOT.jar

REM Parse command line arguments
if not "%1"=="" set PROFILE=%1
if not "%2"=="" set PORT=%2

REM Display startup information
echo.
echo ===============================================
echo    Effigy REST API Server
echo ===============================================
echo Profile: %PROFILE%
echo Port: %PORT%
echo JAR: %JAR_FILE%
echo Time: %DATE% %TIME%
echo ===============================================
echo.

REM Check if JAR file exists
if not exist "%JAR_FILE%" (
    echo ERROR: JAR file '%JAR_FILE%' not found!
    echo Please ensure you're running this script from the deployment directory.
    echo.
    pause
    exit /b 1
)

REM Check if Java is installed
java -version >nul 2>&1
if %ERRORLEVEL% neq 0 (
    echo ERROR: Java is not installed or not in PATH!
    echo Please install Java 21 or later and add it to your PATH.
    echo.
    pause
    exit /b 1
)

REM Set JVM options
set JVM_OPTS=-Xmx512m -Xms256m
set JVM_OPTS=%JVM_OPTS% -Dserver.port=%PORT%
set JVM_OPTS=%JVM_OPTS% -Dspring.profiles.active=%PROFILE%

REM Set SSL configuration if keystore exists
if exist "keystore.p12" (
    set JVM_OPTS=%JVM_OPTS% -Dserver.ssl.key-store=keystore.p12
    set JVM_OPTS=%JVM_OPTS% -Dserver.ssl.key-store-password=changeit
    set JVM_OPTS=%JVM_OPTS% -Dserver.ssl.key-store-type=PKCS12
    echo SSL enabled with keystore.p12
)

REM Set configuration file if exists
if exist "application-production.properties" (
    set JVM_OPTS=%JVM_OPTS% -Dspring.config.additional-location=application-production.properties
    echo Using additional configuration: application-production.properties
)

echo Starting Effigy REST API...
echo Command: java %JVM_OPTS% -jar %JAR_FILE%
echo.

REM Start the application
java %JVM_OPTS% -jar %JAR_FILE%

REM Check exit code
if %ERRORLEVEL% neq 0 (
    echo.
    echo ERROR: Application failed to start or exited with error code %ERRORLEVEL%
    echo.
) else (
    echo.
    echo Application stopped normally.
    echo.
)

pause