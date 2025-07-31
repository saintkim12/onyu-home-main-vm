
apk add rclone fuse

# rclone config
cp rclone.conf.sample ~/.config/rclone/rclone.conf

mkdir -p /mnt/immich-s3

rclone mount immich-s3:immich /mnt/immich-s3 \
  --vfs-cache-mode=writes \
  --allow-other \
  --dir-cache-time=1000h \
  --poll-interval=15s \
  --umask=002 \
  --buffer-size=0 \
  --attr-timeout=1s \
  --log-level INFO \
  --log-file /var/log/rclone-immich.log &

cp rclone.start /etc/local.d/rclone.start
chmod +x /etc/local.d/rclone.start
rc-update add local
