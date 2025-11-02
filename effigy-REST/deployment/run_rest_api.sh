#!/bin/bash
# ==============================================================================
# Effigy REST API Startup Script (Linux/Unix)
# ==============================================================================
# This script starts the Effigy REST API application
# Usage: ./run_rest_api.sh [profile] [port]
#   profile: dev, staging, prod (default: prod)
#   port: port number (default: 8080)
# ==============================================================================

# Set default values
PROFILE=${1:-prod}
PORT=${2:-8080}
JAR_FILE="media-0.0.1-SNAPSHOT.jar"

# Display startup information
echo ""
echo "==============================================="
echo "    Effigy REST API Server"
echo "==============================================="
echo "Profile: $PROFILE"
echo "Port: $PORT"
echo "JAR: $JAR_FILE"
echo "Time: $(date)"
echo "==============================================="
echo ""

# Check if JAR file exists
if [ ! -f "$JAR_FILE" ]; then
    echo "ERROR: JAR file '$JAR_FILE' not found!"
    echo "Please ensure you're running this script from the deployment directory."
    echo ""
    exit 1
fi

# Check if Java is installed
if ! command -v java &> /dev/null; then
    echo "ERROR: Java is not installed or not in PATH!"
    echo "Please install Java 21 or later and add it to your PATH."
    echo ""
    exit 1
fi

# Set JVM options
JVM_OPTS="-Xmx512m -Xms256m"
JVM_OPTS="$JVM_OPTS -Dserver.port=$PORT"
JVM_OPTS="$JVM_OPTS -Dspring.profiles.active=$PROFILE"

# Set SSL configuration if keystore exists
if [ -f "keystore.p12" ]; then
    JVM_OPTS="$JVM_OPTS -Dserver.ssl.key-store=keystore.p12"
    JVM_OPTS="$JVM_OPTS -Dserver.ssl.key-store-password=changeit"
    JVM_OPTS="$JVM_OPTS -Dserver.ssl.key-store-type=PKCS12"
    echo "SSL enabled with keystore.p12"
fi

# Set configuration file if exists
if [ -f "application-production.properties" ]; then
    JVM_OPTS="$JVM_OPTS -Dspring.config.additional-location=application-production.properties"
    echo "Using additional configuration: application-production.properties"
fi

echo "Starting Effigy REST API..."
echo "Command: java $JVM_OPTS -jar $JAR_FILE"
echo ""

# Start the application
java $JVM_OPTS -jar "$JAR_FILE"

# Check exit code
if [ $? -ne 0 ]; then
    echo ""
    echo "ERROR: Application failed to start or exited with error code $?"
    echo ""
    exit 1
else
    echo ""
    echo "Application stopped normally."
    echo ""
fi