#!/bin/bash
set -e
set -x
sudo apt install -y premake premake5 lua desktop-file-utils build-essemtial clang make cmake libgtk-3-dev libpthread-stubs0-dev liblz4-dev libx11-dev libx11-xcb-dev libvulkan-dev libsdl2-dev libiberty-dev libunwind-dev libc++-dev libc++abi-dev ninja-build
git submodule sync
git clone https://github.com/xenia-project/xenia.git
cd ./xenia/
git submodule update --init --recursive --progress
