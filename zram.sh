#!/bin/sh

# https://wiki.debian.org/ZRam
# https://wiki.archlinux.org/index.php/maximizing_performance

FRACTION=75

MEMORY=`perl -ne'/^MemTotal:\s+(\d+)/ && print $1*1024;' < /proc/meminfo`
CPUS=`grep -c processor /proc/cpuinfo`
SIZE=$(( MEMORY * FRACTION / 100 / CPUS ))

CALGO="lzo"

case "$1" in
  "start")
    #param=`modinfo zram|grep num_devices|cut -f2 -d:|tr -d ' '`
    param="num_devices"
    modprobe zram $param=$CPUS
    for n in `seq $CPUS`; do
      i=$((n - 1))
      echo $CALGO > /sys/block/zram$i/comp_algorithm
      echo $SIZE > /sys/block/zram$i/disksize
      mkswap --label zram$i /dev/zram$i
      swapon --priority 10 /dev/zram$i
    done
    ;;
  "stop")
    for n in `seq $CPUS`; do
      i=$((n - 1))
      swapoff /dev/zram$i && echo "disabled disk $n of $CPUS" &
    done
    wait
    sleep .5
    modprobe -r zram
    ;;
  *)
    echo "Usage: `basename $0` (start | stop)"
    exit 1
    ;;
esac
