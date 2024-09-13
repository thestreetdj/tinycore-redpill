#!bin/sh

mkdir -p /docker/jellyfin/config
mkdir -p /docker/jellyfin/cache

curl -kLO# https://github.com/jellyfin/jellyfin-ffmpeg/releases/download/v6.0.1-8/jellyfin-ffmpeg6_6.0.1-8-bookworm_amd64.deb
dpkg-deb -x jellyfin-ffmpeg*.deb temp_dir
tar -xf temp_dir/opt/jellyfin/bin/data.tar.xz -C temp_dir
mkdir -p /usr/lib/jellyfin-ffmpeg
mv -v temp_dir/usr /
cd /usr/lib/jellyfin-ffmpeg
./ffmpeg
