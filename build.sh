#!/bin/sh

sh autogen.sh
./configure --enable-post-processing --disable-data-channels \
    --disable-all-plugins --enable-plugin-echotest --enable-plugin-videoroom \
    --disable-all-transports --enable-websockets
make
make install
