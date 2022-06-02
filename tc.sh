#!/bin/bash
export DISPLAY=:$1
export AFL_NO_AFFINITY=1
#export AFL_PRELOAD=/lib64/libdislocator.so
#Xvfb -screen 0 1x1x8 ${DISPLAY} &
#PID=$!
run() {
      afl-fuzz -i input -o output -m1024 -t8000+ -f infile $@ mksquashfs-lzma testfile test.squash -noappend -ef @@
}

run $2
#kill $PID
