#!/usr/bin/env sh

# if using b43 wifi driver do
# sudo vim /etc/modprobe.d/b43.conf
# ------
# options b43 btcoex=0
# ------


case $1 in
	"on")
	#sudo modprobe bluetooth btusb
	#sudo systemctl start bluetooth.service
	sudo rc-service bluetooth start
	sudo hciconfig hci0 up
	blueman-applet &;;
	"off")
	#sudo modprobe -r bluetooth btusb
	#sudo systemctl stop bluetooth.service
	sudo rc-service bluetooth stop
	sudo hciconfig hci0 down 
	pkill blueman;;
esac
