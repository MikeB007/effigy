# Effigy REST Application - Deployment Verification Script (PowerShell)
# This script verifies that the deployed application is working correctly

Write-Host "🔍 Effigy REST Application - Deployment Verification" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

# Configuration
$APP_PORT = 8443
$HTTP_PORT = 8080
$BASE_URL = "https://localhost:$APP_PORT"
$HTTP_URL = "http://localhost:$HTTP_PORT"

# Function to print colored status messages
function Write-Status {
    param(
        [string]$Type,
        [string]$Message
    )
    
    switch ($Type) {
        "SUCCESS" { Write-Host "✅ $Message" -ForegroundColor Green }
        "ERROR" { Write-Host "❌ $Message" -ForegroundColor Red }
        "WARNING" { Write-Host "⚠️ $Message" -ForegroundColor Yellow }
        "INFO" { Write-Host "ℹ️ $Message" -ForegroundColor White }
    }
}

# Check if Java is installed and version
Write-Host ""
Write-Status "INFO" "Checking Java installation..."

try {
    $javaVersion = java -version 2>&1 | Select-String "version" | Select-Object -First 1
    if ($javaVersion) {
        Write-Status "SUCCESS" "Java is installed: $($javaVersion.ToString().Trim())"
    } else {
        Write-Status "ERROR" "Could not determine Java version"
        exit 1
    }
} catch {
    Write-Status "ERROR" "Java is not installed or not in PATH"
    exit 1
}

# Check if the application JAR exists
Write-Host ""
Write-Status "INFO" "Checking application files..."

if (Test-Path "media-0.0.1-SNAPSHOT.jar") {
    $jarInfo = Get-Item "media-0.0.1-SNAPSHOT.jar"
    $jarSize = [math]::Round($jarInfo.Length / 1MB, 2)
    Write-Status "SUCCESS" "Application JAR found: media-0.0.1-SNAPSHOT.jar ($jarSize MB)"
} else {
    Write-Status "ERROR" "Application JAR not found: media-0.0.1-SNAPSHOT.jar"
    exit 1
}

# Check if configuration file exists
if (Test-Path "application-production.properties") {
    Write-Status "SUCCESS" "Configuration file found: application-production.properties"
} else {
    Write-Status "WARNING" "Configuration file not found: application-production.properties"
}

# Check if SSL keystore exists
if (Test-Path "keystore.p12") {
    $keystoreInfo = Get-Item "keystore.p12"
    $keystoreSize = [math]::Round($keystoreInfo.Length / 1KB, 2)
    Write-Status "SUCCESS" "SSL keystore found: keystore.p12 ($keystoreSize KB)"
} else {
    Write-Status "WARNING" "SSL keystore not found: keystore.p12"
}

# Check if application is running
Write-Host ""
Write-Status "INFO" "Checking if application is running..."

# Check HTTPS port
$httpsPort = Get-NetTCPConnection -LocalPort $APP_PORT -ErrorAction SilentlyContinue
if ($httpsPort) {
    Write-Status "SUCCESS" "Application is listening on HTTPS port $APP_PORT"
    
    # Test HTTPS endpoint (with SSL verification disabled for self-signed cert)
    Write-Status "INFO" "Testing HTTPS endpoint..."
    try {
        # Disable SSL certificate validation for self-signed certificates
        [System.Net.ServicePointManager]::ServerCertificateValidationCallback = {$true}
        $response = Invoke-WebRequest -Uri "$BASE_URL/web" -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Status "SUCCESS" "HTTPS endpoint /web is responding (Status: $($response.StatusCode))"
        } else {
            Write-Status "WARNING" "HTTPS endpoint /web returned status: $($response.StatusCode)"
        }
    } catch {
        Write-Status "WARNING" "HTTPS endpoint /web is not responding: $($_.Exception.Message)"
    }
} else {
    Write-Status "WARNING" "Application is not listening on HTTPS port $APP_PORT"
}

# Check HTTP port
$httpPort = Get-NetTCPConnection -LocalPort $HTTP_PORT -ErrorAction SilentlyContinue
if ($httpPort) {
    Write-Status "SUCCESS" "Application is listening on HTTP port $HTTP_PORT"
    
    # Test HTTP endpoint
    Write-Status "INFO" "Testing HTTP endpoint..."
    try {
        $response = Invoke-WebRequest -Uri "$HTTP_URL/web" -TimeoutSec 10 -UseBasicParsing -ErrorAction Stop
        if ($response.StatusCode -eq 200) {
            Write-Status "SUCCESS" "HTTP endpoint /web is responding (Status: $($response.StatusCode))"
        } else {
            Write-Status "WARNING" "HTTP endpoint /web returned status: $($response.StatusCode)"
        }
    } catch {
        Write-Status "WARNING" "HTTP endpoint /web is not responding: $($_.Exception.Message)"
    }
} else {
    Write-Status "WARNING" "Application is not listening on HTTP port $HTTP_PORT"
}

# Check system resources
Write-Host ""
Write-Status "INFO" "Checking system resources..."

# Memory usage
try {
    $memory = Get-CimInstance -ClassName Win32_OperatingSystem
    $totalMemoryGB = [math]::Round($memory.TotalVisibleMemorySize / 1MB, 2)
    $freeMemoryGB = [math]::Round($memory.FreePhysicalMemory / 1MB, 2)
    $usedMemoryGB = [math]::Round($totalMemoryGB - $freeMemoryGB, 2)
    Write-Status "INFO" "Memory usage: $usedMemoryGB GB / $totalMemoryGB GB"
} catch {
    Write-Status "INFO" "Could not retrieve memory information"
}

# Disk space
try {
    $disk = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DeviceID='C:'"
    $totalSpaceGB = [math]::Round($disk.Size / 1GB, 2)
    $freeSpaceGB = [math]::Round($disk.FreeSpace / 1GB, 2)
    $usedSpaceGB = [math]::Round($totalSpaceGB - $freeSpaceGB, 2)
    $usedPercentage = [math]::Round(($usedSpaceGB / $totalSpaceGB) * 100, 1)
    Write-Status "INFO" "Disk usage: $usedSpaceGB GB / $totalSpaceGB GB ($usedPercentage% used)"
} catch {
    Write-Status "INFO" "Could not retrieve disk information"
}

# Check logs if available
Write-Host ""
Write-Status "INFO" "Checking for log files..."

if (Test-Path "application.log") {
    $logInfo = Get-Item "application.log"
    $logSizeMB = [math]::Round($logInfo.Length / 1MB, 2)
    Write-Status "SUCCESS" "Application log found: application.log ($logSizeMB MB)"
    
    # Check for recent errors
    try {
        $recentContent = Get-Content "application.log" -Tail 50 | Where-Object { $_ -match "error|ERROR" }
        if ($recentContent) {
            Write-Status "WARNING" "Recent errors found in application log"
            Write-Host "Recent errors:" -ForegroundColor Yellow
            $recentContent | Select-Object -Last 5 | ForEach-Object { Write-Host "  $_" -ForegroundColor Gray }
        } else {
            Write-Status "SUCCESS" "No recent errors in application log"
        }
    } catch {
        Write-Status "INFO" "Could not check application log for errors"
    }
} else {
    Write-Status "INFO" "No application.log file found (this is normal for console logging)"
}

# Check if running as Windows service
Write-Host ""
Write-Status "INFO" "Checking Windows service status..."

try {
    $service = Get-Service -Name "EffigyREST" -ErrorAction SilentlyContinue
    if ($service) {
        Write-Status "SUCCESS" "Windows service 'EffigyREST' found - Status: $($service.Status)"
    } else {
        Write-Status "INFO" "Windows service 'EffigyREST' not found (application may be running manually)"
    }
} catch {
    Write-Status "INFO" "Could not check Windows service status"
}

# Final summary
Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Status "INFO" "Deployment verification completed"

# Provide next steps
Write-Host ""
Write-Host "📋 Next Steps:" -ForegroundColor Cyan
Write-Host "• To access the application:"
Write-Host "  - HTTPS: $BASE_URL/web"
Write-Host "  - HTTP:  $HTTP_URL/web"
Write-Host ""
Write-Host "• To check application logs:"
Write-Host "  - Get-Service EffigyREST | Get-EventLog (if using Windows service)"
Write-Host "  - Check console output if running manually"
Write-Host ""
Write-Host "• To stop the application:"
Write-Host "  - Stop-Service EffigyREST (if using Windows service)"
Write-Host "  - Ctrl+C if running in foreground"

Write-Host ""
Write-Status "SUCCESS" "Verification script completed!"

# Reset SSL validation callback
[System.Net.ServicePointManager]::ServerCertificateValidationCallback = $null