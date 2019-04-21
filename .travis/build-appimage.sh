#!/bin/sh -xe

mkdir build
cd build
cmake .. \
  -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr \
  -DCMAKE_C_COMPILER=gcc-5 \
  -DCMAKE_CXX_COMPILER=g++-5 \
  -DCMAKE_BUILD_TYPE=RelWithDebInfo \
  -DENABLE_SANITIZERS=ON
make -j$(nproc)
make DESTDIR=appdir -j$(nproc) install ; find appdir/
rm appdir/usr/share/solvespace/freedesktop/solvespace-*.png
( cd appdir/usr ; ln -s ./share/solvespace ./res ) # https://github.com/solvespace/solvespace/issues/347#issuecomment-485222466
wget -c -nv "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage"
chmod a+x linuxdeployqt-continuous-x86_64.AppImage
unset QTDIR; unset QT_PLUGIN_PATH ; unset LD_LIBRARY_PATH
./linuxdeployqt-continuous-x86_64.AppImage appdir/usr/share/applications/*.desktop -appimage
