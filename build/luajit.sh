#!/usr/bin/env bash

LUAJIT_VERSION_NUM=2.1.0-beta1
LUAJIT_VERSION=LuaJIT-$LUAJIT_VERSION_NUM
ISDKVER=iPhoneOS8.4.sdk
ISDKSIMVER=iPhoneSimulator8.4.sdk

IXCODE=/Applications/Xcode.app/Contents/Developer
ISDK=$IXCODE/Platforms/iPhoneOS.platform/Developer
ISDKSIM=$IXCODE/Platforms/iPhoneSimulator.platform/Developer
ISDKP=/usr/bin/
CC="clang"

wget -O - http://luajit.org/download/$LUAJIT_VERSION.tar.gz | tar xz

cd "$LUAJIT_VERSION"
mkdir -p bin
mkdir -p bin/includes

ISDKF="-arch arm64 -isysroot $ISDK/SDKs/$ISDKVER"
make clean
make HOST_CC="clang -m64 -arch x86_64" CROSS=$ISDKP TARGET_FLAGS="$ISDKF" \
     XCFLAGS="-DLUAJIT_ENABLE_LUA52COMPAT" \
     TARGET_SYS=iOS
cp src/libluajit.a bin/libluajit_arm64.a
cp src/libluajit.so bin/libluajit_arm64.so

ISDKF="-arch armv7 -isysroot $ISDK/SDKs/$ISDKVER"
make clean
make HOST_CC="clang -m32 -arch i386" CROSS=$ISDKP TARGET_FLAGS="$ISDKF" \
     XCFLAGS="-DLUAJIT_ENABLE_LUA52COMPAT" \
     TARGET_SYS=iOS
cp src/libluajit.a bin/libluajit_armv7.a
cp src/libluajit.so bin/libluajit_armv7.so

ISDKF="-arch armv7s -isysroot $ISDK/SDKs/$ISDKVER"
make clean
make HOST_CC="clang -m32 -arch i386" CROSS=$ISDKP TARGET_FLAGS="$ISDKF" \
     XCFLAGS="-DLUAJIT_ENABLE_LUA52COMPAT" \
     TARGET_SYS=iOS
cp src/libluajit.a bin/libluajit_armv7s.a
cp src/libluajit.so bin/libluajit_armv7s.so

ISDKF="-arch i386 -isysroot $ISDKSIM/SDKs/$ISDKSIMVER -miphoneos-version-min=6.0"
make clean
make HOST_CC="clang -m32 -arch i386" CROSS=$ISDKP TARGET_FLAGS="$ISDKF" \
     XCFLAGS="-DLUAJIT_ENABLE_LUA52COMPAT" \
     TARGET_SYS=iOS
cp src/libluajit.a bin/libluajit_i386_sim.a
cp src/libluajit.so bin/libluajit_i386_sim.so

ISDKF="-arch x86_64 -isysroot $ISDKSIM/SDKs/$ISDKSIMVER -miphoneos-version-min=6.0"
make clean
make HOST_CC="clang -m64 -arch x86_64" CROSS=$ISDKP TARGET_FLAGS="$ISDKF" \
     XCFLAGS="-DLUAJIT_ENABLE_LUA52COMPAT -DLUAJIT_ENABLE_GC64" \
     TARGET_SYS=iOS
cp src/libluajit.a bin/libluajit_x64_sim.a
cp src/libluajit.so bin/libluajit_x64_sim.so

cp src/lauxlib.h bin/includes
cp src/lua.h bin/includes
cp src/luaconf.h bin/includes
cp src/lualib.h bin/includes
cp src/luajit.h bin/includes

lipo -create -output bin/libluajit-$LUAJIT_VERSION_NUM.a \
  bin/libluajit_arm64.a \
  bin/libluajit_armv7.a \
  bin/libluajit_armv7s.a \
  bin/libluajit_i386_sim.a \
  bin/libluajit_x64_sim.a

cd bin
tar -zcvf $LUAJIT_VERSION.tar.gz includes libluajit-$LUAJIT_VERSION_NUM.a
