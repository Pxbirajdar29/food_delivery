#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo "╔════════════════════════════════════════╗"
echo "║   🚀 CI/CD SECURITY PIPELINE          ║"
echo "╚════════════════════════════════════════╝"
echo ""

mkdir -p security-reports

echo -e "${YELLOW}[STEP 1/5] Building Docker image...${NC}"
echo "----------------------------------------"
docker build -t food-delivery-backend:latest ./backend
if [ $? -ne 0 ]; then
    echo -e "${RED}❌ BUILD FAILED${NC}"
    exit 1
fi
echo -e "${GREEN}✅ Image built successfully${NC}"
echo ""

echo -e "${YELLOW}[STEP 2/5] Running Trivy Security Scan...${NC}"
echo "----------------------------------------"
docker run --rm \
  -v /var/run/docker.sock:/var/run/docker.sock \
  -v $(pwd)/security-reports:/reports \
  aquasec/trivy:latest \
  image --severity HIGH,CRITICAL \
  --exit-code 1 \
  --format table \
  --output /reports/scan-report.txt \
  food-delivery-backend:latest

if [ $? -ne 0 ]; then
    echo -e "${RED}❌ SECURITY SCAN FAILED - Vulnerabilities found!${NC}"
    echo "📄 Check security-reports/scan-report.txt"
    exit 1
fi
echo -e "${GREEN}✅ Security scan passed${NC}"
echo ""

echo -e "${YELLOW}[STEP 3/5] Stopping old containers...${NC}"
echo "----------------------------------------"
docker-compose down
echo ""

echo -e "${YELLOW}[STEP 4/5] Starting application...${NC}"
echo "----------------------------------------"
docker-compose up -d --build
echo ""

echo -e "${YELLOW}[STEP 5/5] Running health checks...${NC}"
echo "----------------------------------------"
sleep 5
curl -s http://localhost:5000/health
echo ""

echo ""
echo "╔════════════════════════════════════════╗"
echo -e "║   ${GREEN}✅ PIPELINE COMPLETE${NC}                 ║"
echo "║   Application is secure and running!   ║"
echo "╚════════════════════════════════════════╝"
echo ""
echo "📊 Access the app: http://localhost"
echo "📄 Security report: security-reports/scan-report.txt"