#!/bin/sh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

mkdir -p "$SCRIPT_DIR/build"
cd "$SCRIPT_DIR/build"
cmake -DVORBISFILE_LIBRARY:FILEPATH=/usr/lib/x86_64-linux-gnu/libvorbisfile.so -DVORBIS_LIBRARY:FILEPATH=/usr/lib/x86_64-linux-gnu/libvorbis.so ..
make -j$(nproc)
