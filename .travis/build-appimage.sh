#!/bin/sh -xe

mkdir build
cd build
cmake .. \
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr \
  -DCMAKE_C_COMPILER=gcc-5 \
  -DCMAKE_CXX_COMPILER=g++-5
make -j$(nproc)
make DESTDIR=appdir -j$(nproc) install ; find appdir/
cp appdir/usr/share/icons/hicolor/48x48/apps/solvespace.png appdir/
rm -rf appdir/usr/lib/x86_64-linux-gnu appdir/usr/bin/solvespace-cli
strip appdir/usr/bin/solvespace
wget -c -nv "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod a+x linuxdeployqt-continuous-x86_64.AppImage
./linuxdeployqt-continuous-x86_64.AppImage appdir/usr/share/applications/*.desktop -appimage
