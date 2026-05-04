#!/bin/bash
echo "========================================="
echo "   PRACTICAL 6: CI/CD PIPELINE TEST"
echo "========================================="

echo ""
echo "[STEP 1] Building Docker image..."
docker build -t food-delivery-backend:latest ./backend

echo ""
echo "[STEP 2] Running Trivy security scan..."
trivy image --severity HIGH,CRITICAL food-delivery-backend:latest

echo ""
echo "[STEP 3] Testing container..."
docker run -d --name test-backend -p 5001:5000 food-delivery-backend:latest
sleep 3
curl -f http://localhost:5001/health

echo ""
echo "[STEP 4] Cleaning up..."
docker stop test-backend
docker rm test-backend

echo ""
echo "✅ CI/CD Pipeline Test Complete!"