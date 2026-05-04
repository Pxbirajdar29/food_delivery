#!/bin/bash
echo "🔒 Running Trivy (Local Windows Installation)"
echo "=============================================="
echo ""

mkdir -p security-reports

echo "Building Docker image..."
docker build -t food-delivery-backend:latest ./backend

echo ""
echo "Scanning with local Trivy..."
trivy image --severity HIGH,CRITICAL --format table --output security-reports/scan-report.txt food-delivery-backend:latest

echo ""
echo "✅ Scan complete!"
echo "📄 Report: security-reports/scan-report.txt"
echo ""
read -p "Press Enter to continue..."