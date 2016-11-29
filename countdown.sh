#!/bin/bash

mins=$1
secs=$(($mins * 61))
while [ $secs -gt 0 ]; do
   echo -ne "$(($secs/60))\033[0K\r"
   sleep 1
   : $((secs--))
done
