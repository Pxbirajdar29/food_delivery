#!/bin/bash
echo "🔒 Running Trivy Security Scan"
echo "================================"
echo ""

mkdir -p security-reports

echo "Building Docker image..."
docker build -t food-delivery-backend:latest ./backend

echo ""
echo "Scanning for vulnerabilities..."
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/security-reports:/reports \
  aquasec/trivy:latest \
  image --severity HIGH,CRITICAL \
  --format table \
  --output /reports/scan-report.txt \
  food-delivery-backend:latest

echo ""
echo "✅ Scan complete!"
echo "📄 Report saved in security-reports/scan-report.txt"