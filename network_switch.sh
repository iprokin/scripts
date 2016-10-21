#!/usr/bin/env sh

WIFI='wlp2s0'
ETH='enp1s0f0'

case $1 in
    "off")
    sudo ip link set $WIFI down
    sudo ip link set $ETH down
    sudo rc-service wpa_supplicant stop
    sudo rc-service dhcpcd stop
    killall dhcpcd-gtk
    #sudo systemctl stop NetworkManager.service
    #pkill nm-applet
    ;;
    "on")
    sudo ip link set $WIFI up 
    sudo ip link set $ETH up
    sudo rc-service wpa_supplicant start
    sudo rc-service dhcpcd start
    dhcpcd-gtk&
    #sudo systemctl start NetworkManager.service
    #nm-applet&
    ;;
esac
