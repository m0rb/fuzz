#!/bin/bash
[ "$1" == "resync" ] && RESYNC=1 
cat > screenfuzz << _EOF_
mousetrack on
screen 0 ./fuzzchroot.sh ramfs0 1 -M0 $RESYNC
split
focus
screen 1 ./fuzzchroot.sh ramfs1 2 -S1 $RESYNC
split -v
focus
screen 2 ./fuzzchroot.sh ramfs2 3 -S2 $RESYNC
focus
split -v
focus
screen 3 ./fuzzchroot.sh ramfs3 4 -S3 $RESYNC
screen 4 ./sync.sh
prev
_EOF_
screen -c screenfuzz
clear
rm screenfuzz
