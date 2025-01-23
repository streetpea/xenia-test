#!/bin/bash

set -eux

LIB4BIN="https://raw.githubusercontent.com/VHSgunzo/sharun/refs/heads/main/lib4bin"
APPIMAGETOOL="https://github.com/AppImage/appimagetool/releases/download/continuous/appimagetool-x86_64.AppImage"

export APPIMAGE_EXTRACT_AND_RUN=1
export ARCH="$(uname -m)"

pacman -Syu --noconfirm linux-headers \
	binutils \
	patchelf \
	findutils \
	grep \
	sed \
	coreutils \
	strace \
	llvm \
	cmake \
	git \
	pipewire \
	pulseaudio \
	pulseaudio-alsa \
	findutils \
	ninja \
	base-devel \
	gnupg \
	lsb-release \
	python-opencv \
	wget \
	lua \
	gtk3 \
	lz4 \
	glew \
	libx11 \
	sdl2 \
	pkgconf \
	curl \
	binutils \
	vulkan-icd-loader \
	vulkan-radeon \
	vulkan-intel \
	vulkan-nouveau \
	vulkan-tools \
	vulkan-headers \
	xcb-util-keysyms \
	xkeyboard-config \
	wayland \
	libxrandr \
	mesa \
	libxinerama \
	libxcursor \
	clang-tools-extra

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
mkdir bin/
find ../build/bin/Linux/Release/
xvfb-run -a -- find ../build/bin/Linux/Release/ -executable -iname 'xenia*' -type f | xargs -i -t -exec ./lib4bin -p -v -r -e -s -k {} \
  /usr/lib/libGLX* \
  /usr/lib/libstdc++* \
  /usr/lib/libEGL* \
	/usr/lib/dri/* \
	/usr/lib/libvulkan* \
	/usr/lib/pipewire-0.3/* \
	/usr/lib/spa-0.2/*/* \
	/usr/lib/alsa-lib/*
 find ../build/ -executable -iname 'xenia*' -type f | xargs -i -t -exec cp -f {} ./bin/
 ln -frs ./bin/xenia_canary AppRun
 cp ${GITHUB_WORKSPACE}/Xenia-canary.desktop . ; cp ${GITHUB_WORKSPACE}/xenia.png .
 cd ..
./appimagetool -n lucas/
