#!/bin/bash

set -eux

LIB4BIN="https://raw.githubusercontent.com/VHSgunzo/sharun/refs/heads/main/lib4bin"
APPIMAGETOOL="https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"
ICON="https://github.com/xenia-project/xenia/blob/master/assets/icon/256.png?raw=true"

export APPIMAGE_EXTRACT_AND_RUN=1
export ARCH="$(uname -m)"
echo 'test' > ~/version

git clone https://github.com/xenia-canary/xenia-canary.git
cd ./xenia-canary/
git submodule update --init --recursive --progress

mkdir lucas/
wget "$LIB4BIN" -O lucas/lib4bin
chmod +x lucas/lib4bin
wget "$APPIMAGETOOL" -O appimagetool
chmod +x appimagetool

cp -f ${GITHUB_WORKSPACE}/main_init_posix.cc ./src/xenia/base/
python3 xenia-build setup --target_os=linux
python3 xb premake --cc gcc
python3 xb build --config=release

cd ./lucas/
wget "$ICON" -O ./xenia.png
echo '[Desktop Entry]
Version=1.0
Type=Application
Name=Xenia-canary
Exec=xenia_canary
Icon=xenia
Categories=Game;Emulator;
Terminal=false
StartupNotify=false' > Xenia-canary.desktop

find ../build/bin/Linux/Release/
xvfb-run -a -- ./lib4bin -p -v -r -e -s -k \
	../build/bin/Linux/Release/xenia* \
	/usr/lib/libGLX* \
	/usr/lib/libstdc++* \
	/usr/lib/libEGL* \
	/usr/lib/dri/* \
	/usr/lib/libvulkan* \
	/usr/lib/pipewire-0.3/* \
	/usr/lib/spa-0.2/*/* \
	/usr/lib/alsa-lib/*

ln ./sharun ./AppRun
./sharun -g

 cd ..
./appimagetool -n lucas/
