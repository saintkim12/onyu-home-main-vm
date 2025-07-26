#!/bin/sh
set -e

# Git 저장소 clone
# git clone https://github.com/saintkim12/onyu-home-main-vm.git /opt/setup
mkdir -p /opt/setup
cd /opt/setup

# 주입된 .env 파일 불러오기
. ./.env

# git, docker 설치
echo "🔧 Installing base packages..."
apk update
apk add --no-cache git docker docker-compose openrc curl

echo "🔌 Enabling docker service..."
rc-update add docker boot
service docker start

echo "📥 Cloning Git repository..."

if [ ! -d "./$GIT_REPO" ]; then
  git clone -b "$GIT_BRANCH" "$GIT_URL" /opt/setup/main-vm
else
  echo "📦 Repo exists, pulling latest..."
  cd "$GIT_REPO" && git pull && cd ..
fi
cp ./.env ./main-vm
cd main-vm/docker

echo "🚀 Starting all Docker services..."

for dir in */ ; do
  if [ -f "$dir/docker-compose.yaml" ]; then
    echo "🟢 Launching $dir"
    (cd "$dir" && docker-compose up -d)
  fi
done

echo "✅ All services launched."