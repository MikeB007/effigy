# Effigy REST Application - Deployment Package

This directory contains all the files needed to deploy the Effigy REST application to target servers.

## Package Contents

- **media-0.0.1-SNAPSHOT.jar** - The main Spring Boot application JAR file
- **application-production.properties** - Production configuration file
- **keystore.p12** - SSL certificate for HTTPS connections
- **RUN_REST_API.CMD** - Windows startup script for the REST API
- **run_rest_api.sh** - Linux/Unix startup script for the REST API
- **deploy-to-base.ps1** - Windows deployment script
- **transfer-to-base.ps1** - Windows file transfer script
- **verify-deployment.ps1** - Windows verification script
- **DEPLOYMENT.md** - Comprehensive deployment documentation

## Quick Start

### Windows
```cmd
# Run the application directly
RUN_REST_API.CMD

# Run with custom profile and port
RUN_REST_API.CMD dev 9090

# Or deploy using PowerShell scripts
.\deploy-to-base.ps1
.\verify-deployment.ps1
```

### Linux/Unix
```bash
# Make script executable (first time only)
chmod +x run_rest_api.sh

# Run the application
./run_rest_api.sh

# Run with custom profile and port
./run_rest_api.sh staging 9090
```

## Application Startup Options

The run scripts support the following parameters:

### RUN_REST_API.CMD / run_rest_api.sh
```
Usage: [script] [profile] [port]
  profile: dev, staging, prod (default: prod)
  port: port number (default: 8080)

Examples:
  RUN_REST_API.CMD                    # Production mode, port 8080
  RUN_REST_API.CMD dev                # Development mode, port 8080  
  RUN_REST_API.CMD prod 9090          # Production mode, port 9090
```

### Features
- ✅ **Automatic Java detection** - Checks if Java 21+ is installed
- ✅ **SSL support** - Automatically configures SSL if keystore.p12 exists
- ✅ **Configuration loading** - Uses application-production.properties if available
- ✅ **Memory optimization** - Pre-configured JVM memory settings
- ✅ **Error handling** - Clear error messages and proper exit codes
- ✅ **Cross-platform** - Windows (.CMD) and Linux/Unix (.sh) versions

## Requirements

- Java 21 or higher
- Appropriate ports available (default: 8080 for HTTP, 8443 for HTTPS)
- Sufficient memory (recommended: 2GB RAM minimum)

## Troubleshooting

### Common Issues
1. **"Java not found"** - Install Java 21+ and add to PATH
2. **"JAR file not found"** - Ensure you're running from the deployment directory
3. **"Port already in use"** - Use a different port: `RUN_REST_API.CMD prod 9090`

## Support

For detailed deployment instructions, see DEPLOYMENT.md included in this package.