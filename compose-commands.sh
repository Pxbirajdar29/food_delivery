#!/bin/bash
echo "========================================="
echo "   PRACTICAL 7: DOCKER COMPOSE COMMANDS"
echo "========================================="

echo ""
echo "1. Starting all services..."
docker-compose up -d

echo ""
echo "2. Checking service status..."
docker-compose ps

echo ""
echo "3. Testing backend health..."
curl -s http://localhost:5000/health

echo ""
echo "4. Testing frontend..."
curl -s -o /dev/null -w "HTTP Status: %{http_code}\n" http://localhost

echo ""
echo "5. Viewing logs (last 10 lines)..."
docker-compose logs --tail=10

echo ""
echo "6. Stopping all services..."
docker-compose down

echo ""
echo "✅ Docker Compose Practical Complete!"