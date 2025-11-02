# Effigy REST Application - Deployment Package

This directory contains all the files needed to deploy the Effigy REST application to a Windows target server.

## Package Contents

- **media-0.0.1-SNAPSHOT.jar** - The main Spring Boot application JAR file
- **application-production.properties** - Production configuration file
- **keystore.p12** - SSL certificate for HTTPS connections
- **deploy-to-base.ps1** - Windows deployment script  
- **transfer-to-base.ps1** - Windows file transfer script
- **verify-deployment.ps1** - Windows verification script
- **DEPLOYMENT.md** - Comprehensive deployment documentation

## Quick Start

### Windows
```powershell
# Deploy the application
.\deploy-to-base.ps1

# Verify deployment  
.\verify-deployment.ps1
```

## Requirements

- Java 21 or higher
- Windows Server with appropriate ports available (8080 for HTTP, 8443 for HTTPS)
- Sufficient memory (recommended: 2GB RAM minimum)

## Support

For detailed deployment instructions, see DEPLOYMENT.md included in this package.