#!/bin/sh
# retro/build-ppc-panther.sh <out-dylib> [install-name]
#
# Builds the fleet's PowerPC SDL 1.2 slice: generic ppc, Mac OS X 10.3.9 SDK,
# 10.3 floor. Run from the top of this tree on a Lion build mini
# (mini-intel / mini-intel2), which has /usr/bin/gcc-4.0 as a PowerPC cross
# compiler and /Developer/SDKs/MacOSX10.3.9.sdk.
#
# This is old-mac-quakespasm/MacOSX/SDL-rebuild.md's "Build the Panther ppc
# slice" recipe, unchanged apart from building from this tree instead of an
# extracted tarball. That recipe produced the ppc member that quakespasm,
# quake2 and quake3 all ship (sha256 d92222069edfefc9..., see
# matthewdeaves/SDL#4).
#
# --disable-video-x11 is mandatory: SDL's X11 GL backend pulls in OpenGL
# header declarations that conflict with the 10.3.9 SDK's, and every port
# uses the Cocoa/Quartz backend.
#
# The default install name matches an SDL.framework's Versions/A/SDL
# member. quake3 ships a bare dylib and uses
# @executable_path/libSDL-1.2.0.dylib instead.

set -e
OUT=${1:?usage: $0 <out-dylib> [install-name]}
ID=${2:-@executable_path/SDL.framework/Versions/A/SDL}
SDK=/Developer/SDKs/MacOSX10.3.9.sdk

[ -f configure ] && [ -f src/video/quartz/SDL_QuartzVideo.m ] || {
	echo "$0: run from the top of the SDL 1.2 tree" >&2; exit 2; }
[ -d "$SDK" ] || { echo "$0: $SDK missing" >&2; exit 2; }

CC=/usr/bin/gcc-4.0 \
CFLAGS="-arch ppc -isysroot $SDK -mmacosx-version-min=10.3 -O2" \
LDFLAGS="-arch ppc -isysroot $SDK -mmacosx-version-min=10.3" \
./configure --host=powerpc-apple-darwin --build=i686-apple-darwin11 \
	--enable-shared --disable-static \
	--disable-video-x11 --disable-nasm --disable-altivec --disable-cdrom
make -j2
cp build/.libs/libSDL-1.2.0.dylib "$OUT"
install_name_tool -id "$ID" "$OUT"
