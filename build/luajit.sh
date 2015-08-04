#!/usr/bin/env bash

IXCODE=/Applications/Xcode.app/Contents/Developer
ISDK=$IXCODE/Platforms/iPhoneOS.platform/Developer
ISDKVER=iPhoneOS8.4.sdk
ISDKP=/usr/bin/
ISDKF="-arch armv7 -isysroot $ISDK/SDKs/$ISDKVER"

wget -O - http://luajit.org/download/LuaJIT-2.0.4.tar.gz | tar xz

(cd "LuaJIT-2.0.4"; make \
  CC="clang" HOST_CC="clang -m32 -arch i386" \
  XCFLAGS="-DLUAJIT_ENABLE_LUA52COMPAT" \
  CROSS="$ISDKP" TARGET_FLAGS="$ISDKF" TARGET_SYS=iOS)
