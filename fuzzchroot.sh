#!/bin/bash
DIR=$1
DNUM=$2
FSSIZE=2048M
MOUNTS=/proc/mounts
CHROOT=$HOME/chroot/fuzz_chroot
BUDIR=$HOME/fuzz
TC=tc.sh
[ -z "$1" -o -z "$2" ] && echo "Usage: $0 <dirname> <displaynum>" && exit 1

userchroot() {
  sudo chroot --userspec=$(whoami) ${DIR} $@
}

testmount() {
  grep -qF ${DIR}$1 ${MOUNTS} && sudo umount ${DIR}$1
}

bindmount() {
  sudo mount -o bind $1 ${DIR}$1
}

cleanup() {
if grep -qF ${DIR} ${MOUNTS}; then
  testmount /proc
  testmount /sys
  testmount /dev/pts
  sudo umount ${DIR}
fi
}

deploychroot() {
  [ ! -d ${DIR} ] && mkdir ${DIR}
  cleanup
  sudo mount -t tmpfs -o size=${FSSIZE} tmpfs ${DIR}
  ( cd ${CHROOT} ; sudo tar hacf - . ) | ( cd ${DIR} ; sudo tar xf - )
  bindmount /proc
  bindmount /sys
  bindmount /dev/pts
  sudo chmod 777 ${DIR}/dev/*
}

postdeploy() {
  cp ${TC} ${DIR} && chmod +x ${DIR}/${TC} && userchroot ./${TC} ${DNUM} $1
}

deploychroot && postdeploy $3 && cleanup && rm -r ${DIR}
