#!/bin/bash
echo "🔒 Security Scan (Fails on HIGH/CRITICAL)"
echo "==========================================="
echo ""

mkdir -p security-reports

echo "[1/2] Building Docker image..."
docker build -t food-delivery-backend:latest ./backend
if [ $? -ne 0 ]; then
    echo "❌ Docker build failed!"
    exit 1
fi

echo ""
echo "[2/2] Scanning for vulnerabilities..."
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/security-reports:/reports \
  aquasec/trivy:latest \
  image --severity HIGH,CRITICAL \
  --exit-code 1 \
  --format table \
  --output /reports/scan-report.txt \
  food-delivery-backend:latest

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ No HIGH/CRITICAL vulnerabilities found!"
    echo "📄 Report: security-reports/scan-report.txt"
else
    echo ""
    echo "❌ HIGH/CRITICAL vulnerabilities found!"
    echo "📄 Check security-reports/scan-report.txt for details"
fi

echo ""
read -p "Press Enter to continue..."