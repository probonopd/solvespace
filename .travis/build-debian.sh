#!/bin/sh -xe

if echo $TRAVIS_TAG | grep ^v; then BUILD_TYPE=RelWithDebInfo; else BUILD_TYPE=Debug; fi

mkdir build
cd build
cmake .. \
  -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
  -DENABLE_SANITIZERS=ON \
  -DCMAKE_INSTALL_PREFIX=/usr
make VERBOSE=1 -j$(nproc)
make test_solvespace
make DESTDIR=appdir -j$(nproc) install ; find appdir/

sed -i -e 's|^Exec=.*|Exec=solvespace|g' appdir/usr/share/applications/solvespace.desktop
wget -c -nv https://github.com/$(wget -q https://github.com/probonopd/go-appimage/releases -O - | grep "appimagetool-.*-x86_64.AppImage" | head -n 1 | cut -d '"' -f 2)
chmod +x ./appimagetool-*.AppImage
./appimagetool-*.AppImage deploy appdir/usr/share/applications/*.desktop
cp appdir/usr/share/icons/hicolor/48x48/apps/solvespace.png appdir/ # 128x128 or 256x256 would be better
./appimagetool-*.AppImage appdir/
