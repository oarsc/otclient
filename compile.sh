#!/bin/bash

if [ -f "/.dockerenv" ] || [ -f "/.dockerinit" ]; then
  OTCLIENT_PATH=/otclient
  mkdir -p "$OTCLIENT_PATH/build"
  cd "$OTCLIENT_PATH/build"
  cmake -DVORBISFILE_LIBRARY:FILEPATH=/usr/lib/x86_64-linux-gnu/libvorbisfile.so -DVORBIS_LIBRARY:FILEPATH=/usr/lib/x86_64-linux-gnu/libvorbis.so ..
  make -j$(nproc)
else
  if [ "$(docker inspect -f '{{.State.Running}}' "otb")" = "false" ]; then
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    sh "$SCRIPT_DIR/setup-and-run-docker.sh"
  else
    echo " [#] Building already running on docker container"
  fi
fi
