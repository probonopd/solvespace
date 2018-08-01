#!/bin/sh -xe

if echo $TRAVIS_TAG | grep ^v; then BUILD_TYPE=RelWithDebInfo; else BUILD_TYPE=Debug; fi

mkdir build
cd build
# We build without the GUI until Travis updates to an Ubuntu version with GTK 3.16+.
cmake .. \
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr \
  -DCMAKE_C_COMPILER=gcc-5 \
  -DCMAKE_CXX_COMPILER=g++-5 \
  -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
  -DENABLE_SANITIZERS=ON
make -j$(nproc)
make DESTDIR=appdir -j$(nproc) install ; find appdir/

wget -c -nv "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod a+x linuxdeployqt-continuous-x86_64.AppImage
unset QTDIR; unset QT_PLUGIN_PATH ; unset LD_LIBRARY_PATH
export VERSION=$(git rev-parse --short HEAD) # linuxdeployqt uses this for naming the file
./linuxdeployqt-continuous-x86_64.AppImage appdir/usr/share/applications/*.desktop -appimage
