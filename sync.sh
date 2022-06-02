#!/bin/bash
set -x
sleep 15
DIR=/home/morb/fuzz
syncdir() {
  for d in {0..4}; do
    D=${DIR}/ramfs${d}/output
    [ "$d" != "$2" ] && [ ! -f "lock" ] && ( cd $1; tar cf - $2 2>/dev/null ) | ( cd ${D}; tar -x --overwrite -f - ) 
  done
}

for c in {0..3}; do 
  R=${DIR}/ramfs${c}/output
  IWFLAGS="-qqe modify -r ${R}/${c}"
  ( while true; do inotifywait ${IWFLAGS} && syncdir ${R} ${c} || sleep 1; done ) &
  PID[${c}]=$!
done

while true ; do 
     sleep 1;
done

for c in {0..3}; do
      kill $PID[${c}]
done
