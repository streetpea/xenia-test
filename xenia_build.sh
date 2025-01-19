#!/bin/bash
echo $PATH
set -e
set -x
mkdir lucas/
sudo apt install -y cmake findutils ninja-build libc6-dev build-essential python3-opencv wget lua5.4 libgtk-3-dev liblz4-dev libglew-dev libx11-dev libsdl2-dev pkg-config curl libcurl4-gnutls-dev desktop-file-utils binutils make cmake libgtk-3-dev libpthread-stubs0-dev liblz4-dev libx11-dev libx11-xcb-dev libvulkan-dev libsdl2-dev libiberty-dev libc++-dev libc++abi-dev ninja-build python3-pip git ninja-build libvulkan-dev libxcb-keysyms1-dev libxkbcommon-dev libwayland-dev libx11-xcb-dev libxrandr-dev libgl-dev libxinerama-dev libxcursor-dev
#wget -c "https://github.com/premake/premake-core/releases/download/v5.0.0-beta4/premake-5.0.0-beta4-linux.tar.gz" ; tar xvf premake-5.0.0-beta4-linux.tar.gz ; chmod +x premake5 ; sudo cp premake5 /usr/bin/
sudo apt remove --purge llvm clang -y
sudo apt autoremove -y
wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh 18
sudo apt install -y llvm-18 llvm-18-dev clang-18 lld-18 llvm-18-tools binutils-gold lld
sudo ln -sf /usr/bin/clang-18 /usr/bin/clang
sudo ln -sf /usr/bin/llvm-config-18 /usr/bin/llvm-config
export AR=llvm-ar-18
export LD=ld.lld
#export LD=gold
#export CXXFLAGS="$CXXFLAGS -v -Wno-integer-overflow -fuse-ld=lld -fno-lto"
#export CXXFLAGS="-lrt"
#export LDFLAGS="-lrt"
export CXX=clang++-18
export CC=clang-18
#export LDFLAGS="-fno-lto"
#git submodule sync
git clone https://github.com/xenia-canary/xenia-canary.git
cd ./xenia-canary/
git submodule update --init --recursive --progress
#git submodule deinit -f premake5
#git rm --cached premake5
#sed -i 's,"FatalWarnings",--"FatalWarnings",g' premake5.lua
#python3 xb premake --cc clang --devenv=cmake && python3 xb build --config=release
python3 xb premake --cc clang --devenv=cmake
mkdir build/
cd ./build/
cmake .. -G ninja
#make -v CXX=clang++-18 CC=clang-18 CXXFLAGS="-Wno-integer-overflow -fvar-tracking-assignments -fno-lto" LDFLAGS="-fvar-tracking-assignments -fno-lto" && make install --prefix=${GITHUB_WORKSPACE}/lucas/
