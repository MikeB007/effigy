# Effigy REST - Maven Distribution Tasks

This document describes the Maven tasks available for building and distributing the Effigy REST application.

## Available Maven Tasks

### `mvn clean package -P dist`
**Purpose**: Complete build and distribution package creation
**What it does**:
1. Cleans previous build artifacts
2. Compiles source code with Java 21
3. Runs unit tests
4. Packages the Spring Boot JAR
5. Creates deployment directory with all necessary files
6. Generates ZIP package for distribution

**Output**: `effigy-rest-deployment-package-0.0.1-SNAPSHOT.zip`

### Usage Examples

#### Quick Distribution (Recommended)
```bash
# Windows
.\mvnw clean package -P dist
```

#### With Verbose Output
```bash
# Windows
.\mvnw clean package -P dist -X
```

#### Skip Tests (for rapid iterations)
```bash
# Windows
.\mvnw clean package -P dist -DskipTests
```

## Deployment Package Contents

The `dist` profile creates a complete deployment package containing:

- **Application JAR** - Spring Boot executable JAR
- **Configuration** - Production properties and SSL keystore
- **Scripts** - Deployment and transfer scripts for Windows
- **Verification** - Scripts to verify successful deployment
- **Documentation** - Complete deployment guide and README

## Build Process Flow

1. **Clean Phase** - Removes previous build artifacts
2. **Compile Phase** - Compiles Java source with Java 21 target
3. **Test Phase** - Runs unit tests to ensure code quality
4. **Package Phase** - Creates Spring Boot JAR with dependencies
5. **Distribution Phase** - Assembles deployment package and creates ZIP

## File Locations

```
target/
  media-0.0.1-SNAPSHOT.jar           # Main application JAR
deployment/                          # Staging directory (auto-generated)
  media-0.0.1-SNAPSHOT.jar          # Application copy
  application-production.properties  # Production config
  keystore.p12                       # SSL certificate
  deploy-to-base.ps1                 # Windows deployment script
  transfer-to-base.ps1               # Windows transfer script
  verify-deployment.ps1              # Windows verification script
  DEPLOYMENT.md                      # Deployment documentation
  README.md                          # Package guide (copied from README-DEPLOYMENT.md)
effigy-rest-deployment-package-0.0.1-SNAPSHOT.zip  # Final distribution package

# Source templates (stored once, copied when needed):
README-DEPLOYMENT.md                 # Template for deployment package README
DEPLOYMENT.md                        # Comprehensive deployment guide
```

## Customization

To modify the distribution process:

1. **Edit deployment files** - Update the source templates:
   - `README-DEPLOYMENT.md` - Template for package README (copied as README.md)
   - `DEPLOYMENT.md` - Comprehensive deployment documentation
   - PowerShell scripts (.ps1) for deployment automation

2. **Modify Maven configuration** - Edit the `dist` profile in `pom.xml`:
   - Add/remove files in the `maven-antrun-plugin` configuration
   - Modify ZIP package name or format
   - Add additional build steps or validations

3. **Assembly configuration** - Edit `src/assembly/deployment.xml`:
   - Change which files are included in the ZIP package
   - Modify file mappings or transformations

## Troubleshooting

### Common Issues

1. **Missing Files**: Ensure all referenced files exist before running dist
2. **Java Version**: Verify Java 21 is installed and JAVA_HOME is set correctly
3. **Memory Issues**: Increase Maven memory with `MAVEN_OPTS=-Xmx2g`
4. **Permission Issues**: Ensure write permissions in project directory

### Debug Commands

```bash
# Check Java version
java -version

# Verify Maven configuration  
.\mvnw help:effective-pom

# List available profiles
.\mvnw help:all-profiles
```

## Integration with CI/CD

The `dist` profile is designed to work with continuous integration:

```yaml
# GitHub Actions example
- name: Build and Package
  run: ./mvnw clean package -P dist
  
- name: Upload Artifacts
  uses: actions/upload-artifact@v3
  with:
    name: deployment-package
    path: effigy-rest-deployment-package-*.zip
```