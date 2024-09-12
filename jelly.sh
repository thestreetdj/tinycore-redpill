#!bin/sh

mkdir -p /docker/jellyfin/config
mkdir -p /docker/jellyfin/cache
mkdir -p /docker/jellyfin/video

curl -kLO# https://github.com/jellyfin/jellyfin-ffmpeg/releases/download/v6.0.1-8/jellyfin-ffmpeg_6.0.1-8_portable_linux64-gpl.tar.xz
tar xf jellyfin-ffmpeg*.tar.xz
mkdir -p /usr/lib/jellyfin-ffmpeg
cp -v ff* /bin
mv -v ff* /usr/lib/jellyfin-ffmpeg
cd /usr/lib/jellyfin-ffmpeg
./ffmpeg
