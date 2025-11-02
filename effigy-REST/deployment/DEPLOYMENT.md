# 🚀 Deployment Guide: Effigy REST API to Server "base"

## Prerequisites on Target Server "base"

### Java Requirements
- **Java 21** (OpenJDK or Oracle JDK)
- Verify with: `java -version`

### Network Requirements
- **Port 8443** (HTTPS) - Primary application port
- **Port 8080** (HTTP) - Management/health checks
- **Firewall** configured to allow these ports

## 📦 Deployment Files

You need to copy these files to server "base":

```
├── media-0.0.1-SNAPSHOT.jar           # Main application JAR
├── application-production.properties   # Production configuration
├── keystore.p12                       # SSL certificate
├── deploy-to-base.sh                  # Linux deployment script
└── deploy-to-base.ps1                 # Windows deployment script
```

## 🐧 Linux/Ubuntu Server Deployment

### Option 1: Automated Script Deployment

1. **Copy files to server:**
   ```bash
   scp media-0.0.1-SNAPSHOT.jar user@base:/tmp/
   scp application-production.properties user@base:/tmp/
   scp keystore.p12 user@base:/tmp/
   scp deploy-to-base.sh user@base:/tmp/
   ```

2. **Run deployment script:**
   ```bash
   ssh user@base
   cd /tmp
   chmod +x deploy-to-base.sh
   sudo ./deploy-to-base.sh
   ```

### Option 2: Manual Deployment

1. **Create application user and directories:**
   ```bash
   sudo useradd -r -m effigy
   sudo mkdir -p /opt/effigy/{bin,config,logs,ssl}
   ```

2. **Copy files:**
   ```bash
   sudo cp media-0.0.1-SNAPSHOT.jar /opt/effigy/bin/
   sudo cp application-production.properties /opt/effigy/config/
   sudo cp keystore.p12 /opt/effigy/ssl/
   sudo chown -R effigy:effigy /opt/effigy
   ```

3. **Create systemd service:**
   ```bash
   sudo nano /etc/systemd/system/effigy-rest.service
   ```
   Copy the service configuration from the deployment script.

4. **Start service:**
   ```bash
   sudo systemctl daemon-reload
   sudo systemctl enable effigy-rest
   sudo systemctl start effigy-rest
   ```

## 🪟 Windows Server Deployment

### Option 1: Automated Script Deployment

1. **Copy files to server:**
   ```powershell
   Copy-Item *.jar \\base\C$\temp\
   Copy-Item *.properties \\base\C$\temp\
   Copy-Item *.p12 \\base\C$\temp\
   Copy-Item deploy-to-base.ps1 \\base\C$\temp\
   ```

2. **Run deployment script (as Administrator):**
   ```powershell
   # On server "base" as Administrator
   cd C:\temp
   .\deploy-to-base.ps1
   ```

### Option 2: Manual Deployment

1. **Create directories:**
   ```powershell
   New-Item -ItemType Directory -Force -Path "C:\effigy\bin"
   New-Item -ItemType Directory -Force -Path "C:\effigy\config"
   New-Item -ItemType Directory -Force -Path "C:\effigy\logs"
   New-Item -ItemType Directory -Force -Path "C:\effigy\ssl"
   ```

2. **Copy files and install as Windows service using NSSM**

## 🔧 Configuration Options

### Environment-Specific Settings

Edit `application-production.properties` before deployment:

```properties
# Change server settings
server.port=8443

# Database configuration (if needed)
spring.datasource.url=jdbc:mysql://database-server:3306/effigy
spring.datasource.username=effigy_user
spring.datasource.password=secure_password

# Logging
logging.file.name=logs/effigy-app.log
logging.level.root=INFO
```

### SSL Certificate

For production, replace `keystore.p12` with a real SSL certificate:

```bash
# Generate new certificate for your domain
keytool -genkeypair -alias tomcat -keyalg RSA -keysize 2048 \
  -storetype PKCS12 -keystore keystore.p12 -validity 365 \
  -dname "CN=your-domain.com,OU=IT,O=YourCompany,L=City,ST=State,C=US"
```

## 🌐 Access Your Application

After successful deployment:

- **HTTPS**: `https://base:8443`
- **HTTP**: `http://base:8080`

### API Endpoints

- Media API: `https://base:8443/api/media/folders`
- News API: `https://base:8443/api/news`
- Trading API: `https://base:8443/api/tv/help`

## 📊 Monitoring & Management

### Check Service Status

**Linux:**
```bash
sudo systemctl status effigy-rest
sudo journalctl -u effigy-rest -f  # Follow logs
```

**Windows:**
```powershell
Get-Service EffigyRestAPI
Get-EventLog -LogName Application -Source EffigyRestAPI
```

### Performance Tuning

Default JVM settings in deployment:
- Initial heap: 512MB (`-Xms512m`)
- Maximum heap: 2GB (`-Xmx2g`)
- Garbage Collector: G1GC

Adjust based on server resources.

## 🛠️ Troubleshooting

### Common Issues

1. **Port conflicts**: Change ports in `application-production.properties`
2. **Java version**: Ensure Java 21 is installed and in PATH
3. **Permissions**: Ensure application user has read/write access to directories
4. **Firewall**: Verify ports 8080 and 8443 are open
5. **SSL issues**: Check keystore path and password

### Logs Location

- **Linux**: `/opt/effigy/logs/effigy-app.log`
- **Windows**: `C:\effigy\logs\effigy-app.log`

## 🔄 Updates

To deploy updates:

1. Stop the service
2. Replace the JAR file
3. Start the service

**Linux:**
```bash
sudo systemctl stop effigy-rest
sudo cp new-version.jar /opt/effigy/bin/media-0.0.1-SNAPSHOT.jar
sudo systemctl start effigy-rest
```

**Windows:**
```powershell
Stop-Service EffigyRestAPI
Copy-Item new-version.jar C:\effigy\bin\media-0.0.1-SNAPSHOT.jar
Start-Service EffigyRestAPI
```

---

🎉 **Your Spring Boot application with Java 21 is now ready for production deployment on server "base"!**