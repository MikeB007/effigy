# PowerShell deployment script for Windows Server "base"
# Run this script on the target Windows server as Administrator

param(
    [string]$ServerIP = "localhost",
    [string]$InstallPath = "C:\effigy"
)

Write-Host "🚀 Deploying Effigy REST API to Windows server 'base'" -ForegroundColor Green

# Configuration
$AppName = "effigy-rest"
$ServiceName = "EffigyRestAPI"
$JarFile = "media-0.0.1-SNAPSHOT.jar"

Write-Host "📋 Deployment Configuration:" -ForegroundColor Yellow
Write-Host "  • Application: $AppName"
Write-Host "  • Install Path: $InstallPath"
Write-Host "  • Service: $ServiceName"
Write-Host "  • JAR: $JarFile"
Write-Host ""

# Check if running as Administrator
if (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "❌ Please run as Administrator" -ForegroundColor Red
    exit 1
}

# Step 1: Create application directory
Write-Host "📁 Creating application directory..." -ForegroundColor Yellow
New-Item -ItemType Directory -Force -Path "$InstallPath\bin"
New-Item -ItemType Directory -Force -Path "$InstallPath\config"
New-Item -ItemType Directory -Force -Path "$InstallPath\logs"
New-Item -ItemType Directory -Force -Path "$InstallPath\ssl"

# Step 2: Copy application files
Write-Host "📦 Copying application files..." -ForegroundColor Yellow
Copy-Item $JarFile "$InstallPath\bin\"
Copy-Item "application-production.properties" "$InstallPath\config\"
Copy-Item "keystore.p12" "$InstallPath\ssl\"

# Step 3: Download and install NSSM (Non-Sucking Service Manager) if not exists
$nssmPath = "$InstallPath\nssm.exe"
if (!(Test-Path $nssmPath)) {
    Write-Host "📥 Downloading NSSM..." -ForegroundColor Yellow
    $nssmUrl = "https://nssm.cc/release/nssm-2.24.zip"
    $tempZip = "$env:TEMP\nssm.zip"
    Invoke-WebRequest -Uri $nssmUrl -OutFile $tempZip
    Expand-Archive -Path $tempZip -DestinationPath "$env:TEMP\nssm" -Force
    Copy-Item "$env:TEMP\nssm\nssm-2.24\win64\nssm.exe" $nssmPath
    Remove-Item $tempZip -Force
    Remove-Item "$env:TEMP\nssm" -Recurse -Force
}

# Step 4: Create Windows service
Write-Host "🔧 Creating Windows service..." -ForegroundColor Yellow

# Remove existing service if it exists
$existingService = Get-Service -Name $ServiceName -ErrorAction SilentlyContinue
if ($existingService) {
    Write-Host "  Removing existing service..." -ForegroundColor Yellow
    & $nssmPath stop $ServiceName
    & $nssmPath remove $ServiceName confirm
}

# Install new service
$javaPath = (Get-Command java).Source
$jarPath = "$InstallPath\bin\$JarFile"
$configPath = "$InstallPath\config\application-production.properties"
$keystorePath = "$InstallPath\ssl\keystore.p12"

& $nssmPath install $ServiceName $javaPath
& $nssmPath set $ServiceName Parameters "-jar `"$jarPath`" --spring.profiles.active=production --spring.config.location=classpath:/application.properties,file:$configPath --server.ssl.key-store=$keystorePath"
& $nssmPath set $ServiceName AppDirectory $InstallPath
& $nssmPath set $ServiceName DisplayName "Effigy REST API"
& $nssmPath set $ServiceName Description "Effigy REST API Service with Java 21 and Spring Boot 3.4.0"
& $nssmPath set $ServiceName Start SERVICE_AUTO_START

# Step 5: Configure firewall
Write-Host "🔥 Configuring Windows Firewall..." -ForegroundColor Yellow
New-NetFirewallRule -DisplayName "Effigy REST API HTTPS" -Direction Inbound -Protocol TCP -LocalPort 8443 -Action Allow
New-NetFirewallRule -DisplayName "Effigy REST API HTTP" -Direction Inbound -Protocol TCP -LocalPort 8080 -Action Allow

# Step 6: Start service
Write-Host "🚀 Starting service..." -ForegroundColor Yellow
Start-Service $ServiceName

# Step 7: Check status
Write-Host ""
Write-Host "✅ Deployment completed!" -ForegroundColor Green
Write-Host ""
Write-Host "📊 Service Status:" -ForegroundColor Yellow
Get-Service $ServiceName | Format-Table -AutoSize

Write-Host ""
Write-Host "🌐 Application URLs:" -ForegroundColor Yellow
$localIP = (Get-NetIPAddress -AddressFamily IPv4 | Where-Object {$_.IPAddress -ne "127.0.0.1"}).IPAddress[0]
Write-Host "  • HTTPS: https://$localIP:8443"
Write-Host "  • HTTP:  http://$localIP:8080"
Write-Host ""
Write-Host "📝 Useful Commands:" -ForegroundColor Yellow
Write-Host "  • Check service status: Get-Service $ServiceName"
Write-Host "  • Stop service: Stop-Service $ServiceName"
Write-Host "  • Start service: Start-Service $ServiceName"
Write-Host "  • Restart service: Restart-Service $ServiceName"
Write-Host "  • View logs: Get-EventLog -LogName Application -Source $ServiceName"
Write-Host ""
Write-Host "🎉 Deployment complete! Your application should be running on server 'base'" -ForegroundColor Green