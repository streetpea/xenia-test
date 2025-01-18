#!/bin/bash
set -e
set -x
wget -c -q "https://github.com/premake/premake-core/releases/download/v5.0.0-beta4/premake-5.0.0-beta4-linux.tar.gz" ; tar xvf premake-5.0.0-beta4-linux.tar.gz ; chmod +x premake5 && sudo mv premake5 /usr/bin/
sudo apt install -y lua5.4 desktop-file-utils build-essential clang make cmake libgtk-3-dev libpthread-stubs0-dev liblz4-dev libx11-dev libx11-xcb-dev libvulkan-dev libsdl2-dev libiberty-dev libc++-dev libc++abi-dev ninja-build
git submodule sync
git clone https://github.com/xenia-project/xenia.git
cd ./xenia/
git submodule update --init --recursive --progress
python3 xb build
