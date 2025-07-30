#!/bin/sh
set -e

GIT_USER=saintkim12
GIT_REPO=onyu-home-main-vm
GIT_BRANCH=main
GIT_URL=https://github.com/${GIT_USER}/${GIT_REPO}.git
MAIN_VM_DIR=/opt/setup/main-vm
YOUR_SERVER_IP='<your-server-ip>'

mkdir -p /opt/setup
cd /opt/setup

### [1] Alpine 패키지 및 Docker 설치
echo "📦 Installing Docker..."
apk update
apk add --no-cache docker docker-compose git curl openrc

echo "🔌 Enabling docker service..."
rc-update add docker boot
service docker start

echo "📥 Cloning Git repository..."

### [2] Git 저장소 클론
if [ ! -d "$MAIN_VM_DIR" ]; then
  git clone -b "$GIT_BRANCH" "$GIT_URL" "$MAIN_VM_DIR"
else
  echo "📦 Repo exists, pulling latest..."
  cd $MAIN_VM_DIR && git pull && cd ..
fi

### [3] 메인 디렉토리로 이동
mkdir -p $MAIN_VM_DIR
cd $MAIN_VM_DIR

### [4] Portainer Docker 컨테이너 실행
echo "🚀 Starting Portainer..."
cd portainer
export PORTAINER_PORT=8100
docker-compose up -d

echo "✅ Portainer started on :$PORTAINER_PORT"
echo "👉 Access at: http://$YOUR_SERVER_IP:$PORTAINER_PORT"

echo ""
echo "📝 Next Step:"
echo "1. Open Portainer UI"
echo "2. Set Stack and Run Container"

