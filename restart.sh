#!/bin/sh
YOUR_SERVER_IP='<your-server-ip>'
MAIN_VM_DIR=/opt/setup/main-vm
echo "🔁 Restarting Docker + Portainer..."

service docker restart

cd "$MAIN_VM_DIR/portainer"
docker-compose down
docker-compose up -d

echo "✅ Portainer restarted on :$PORTAINER_PORT"
echo "👉 Access at: http://$YOUR_SERVER_IP:$PORTAINER_PORT"
