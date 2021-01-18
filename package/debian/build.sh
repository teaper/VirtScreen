#!/bin/bash

PKGVER=0.3.2
# Required for debmake
DEBEMAIL="www@teaper.dev"
DEBFULLNAME="Season Hsiao"
export PKGVER DEBEMAIL DEBFULLNAME

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
ROOT=$SCRIPT_DIR/../..

# Generate necessary files for package building (generated by debmake)
cd $ROOT/package/debian
cp $ROOT/virtscreen-$PKGVER.tar.gz .
tar -xzmf virtscreen-$PKGVER.tar.gz
cp $ROOT/package/debian/Makefile \
    $ROOT/package/debian/virtscreen-$PKGVER/Makefile
cd $ROOT/package/debian/virtscreen-$PKGVER
debmake --yes -b':sh'

# copy files to build
# debmake files
mkdir -p $ROOT/package/debian/build
cp -R $ROOT/package/debian/virtscreen-$PKGVER/debian \
    $ROOT/package/debian/build/debian
cp $ROOT/package/debian/Makefile \
    $ROOT/package/debian/build/
cp $ROOT/package/debian/{control,README.Debian} \
    $ROOT/package/debian/build/debian/
# binary and data files
cp $ROOT/package/appimage/VirtScreen.AppImage \
    $ROOT/package/debian/build/
cp $ROOT/virtscreen.desktop \
    $ROOT/package/debian/build/
cp -R $ROOT/data \
    $ROOT/package/debian/build/

# Build .deb package
cd $ROOT/package/debian/build
dpkg-buildpackage -b

# cleanup
rm -rf $ROOT/package/debian/virtscreen-$PKGVER \
    $ROOT/package/debian/*.tar.gz
