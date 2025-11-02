# PowerShell script to transfer files to Windows server "base"
# Usage: .\transfer-to-base.ps1 -ServerName "base" -Username "administrator"

param(
    [Parameter(Mandatory=$true)]
    [string]$ServerName = "base",
    
    [Parameter(Mandatory=$false)]
    [string]$Username = "Administrator",
    
    [Parameter(Mandatory=$false)]
    [string]$DeployPath = "C:\temp\effigy-deploy"
)

Write-Host "🚀 Transferring Effigy REST API to Windows server: $ServerName" -ForegroundColor Green

# Check if files exist
if (!(Test-Path "target\media-0.0.1-SNAPSHOT.jar")) {
    Write-Host "❌ JAR file not found. Please run: .\mvnw.cmd clean package -DskipTests" -ForegroundColor Red
    exit 1
}

if (!(Test-Path "keystore.p12")) {
    Write-Host "❌ Keystore not found. Please ensure keystore.p12 exists" -ForegroundColor Red
    exit 1
}

Write-Host "📦 Creating deployment package..." -ForegroundColor Yellow

# Create deployment package
New-Item -ItemType Directory -Force -Path "deployment-package" | Out-Null
Copy-Item "target\media-0.0.1-SNAPSHOT.jar" "deployment-package\"
Copy-Item "application-production.properties" "deployment-package\"
Copy-Item "keystore.p12" "deployment-package\"
Copy-Item "deploy-to-base.ps1" "deployment-package\"
Copy-Item "DEPLOYMENT.md" "deployment-package\"

Write-Host "📤 Transferring files to \\$ServerName\$($DeployPath.Replace(':','$'))" -ForegroundColor Yellow

try {
    # Create remote directory
    $remotePath = "\\$ServerName\$($DeployPath.Replace(':','$'))"
    New-Item -ItemType Directory -Force -Path $remotePath -ErrorAction Stop | Out-Null
    
    # Copy files
    Copy-Item -Path "deployment-package\*" -Destination $remotePath -Force -ErrorAction Stop
    
    Write-Host "✅ Files transferred successfully!" -ForegroundColor Green
    Write-Host ""
    Write-Host "🔧 Next steps on server '$ServerName':" -ForegroundColor Yellow
    Write-Host "1. Remote to server: mstsc /v:$ServerName" -ForegroundColor White
    Write-Host "2. Navigate to: $DeployPath" -ForegroundColor White
    Write-Host "3. Run as Administrator: .\deploy-to-base.ps1" -ForegroundColor White
    Write-Host ""
    Write-Host "📖 For detailed instructions, see: DEPLOYMENT.md" -ForegroundColor Yellow
    
    # Alternative: Run deployment remotely via PowerShell remoting
    Write-Host ""
    Write-Host "🔄 Or deploy remotely (if PowerShell remoting enabled):" -ForegroundColor Cyan
    Write-Host "Invoke-Command -ComputerName $ServerName -ScriptBlock { cd '$DeployPath'; .\deploy-to-base.ps1 }" -ForegroundColor White

} catch {
    Write-Host "❌ Failed to transfer files: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 Alternative methods:" -ForegroundColor Yellow
    Write-Host "1. Use RDP and copy files manually" -ForegroundColor White
    Write-Host "2. Use robocopy: robocopy deployment-package \\$ServerName\$($DeployPath.Replace(':','$')) /E" -ForegroundColor White
    Write-Host "3. Use FTP/SFTP if available" -ForegroundColor White
}

# Cleanup
Remove-Item -Path "deployment-package" -Recurse -Force

Write-Host ""
Write-Host "🎉 Ready for deployment on server 'base'!" -ForegroundColor Green