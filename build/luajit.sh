#!/usr/bin/env bash

IXCODE=`xcode-select -print-path`
ISDK=$IXCODE/Platforms/iPhoneOS.platform/Developer
ISDKVER=iPhoneOS8.4.sdk
ISDKP=/usr/bin/
ISDKF="-arch armv7 -isysroot $ISDK/SDKs/$ISDKVER"
make HOST_CC="gcc -m32 -arch i386" CROSS=$ISDKP TARGET_FLAGS="$ISDKF" \
     TARGET_SYS=iOS

wget -O - http://luajit.org/download/LuaJIT-2.0.4.tar.gz | tar xz

cd LuaJIT-2.0.4 && \
  make HOST_CC="gcc -m32 -arch i386" CROSS=$ISDKP TARGET_FLAGS="$ISDKF" \
  TARGET_SYS=iOS
