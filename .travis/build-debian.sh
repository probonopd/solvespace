#!/bin/sh -xe

if echo $TRAVIS_TAG | grep ^v; then BUILD_TYPE=RelWithDebInfo; else BUILD_TYPE=Debug; fi

mkdir build
cd build
# We build without the GUI until Travis updates to an Ubuntu version with GTK 3.22.
cmake .. -DCMAKE_C_COMPILER=clang-3.9 -DCMAKE_CXX_COMPILER=clang++-3.9 \
  -DCMAKE_BUILD_TYPE=$BUILD_TYPE \
  -DENABLE_GUI=OFF \
  -DENABLE_SANITIZERS=ON
  -DCMAKE_INSTALL_PREFIX=/usr
make VERBOSE=1 -j$(nproc)
make test_solvespace

# Generate AppImage
make DESTDIR=appdir install ; find appdir/
wget -c "https://github.com/probonopd/linuxdeployqt/releases/download/continuous/linuxdeployqt-continuous-x86_64.AppImage" 
chmod a+x linuxdeployqt*.AppImage
unset QTDIR; unset QT_PLUGIN_PATH ; unset LD_LIBRARY_PATH
./linuxdeployqt*.AppImage ./appdir/usr/share/applications/*.desktop -bundle-non-qt-libs
./linuxdeployqt*.AppImage ./appdir/usr/share/applications/*.desktop -appimage
find ./appdir -executable -type f -exec ldd {} \; | grep " => /usr" | cut -d " " -f 2-3 | sort | uniq
curl --upload-file ./SolveSpace*.AppImage https://transfer.sh/SolveSpace-git.$(git rev-parse --short HEAD)-x86_64.AppImage
