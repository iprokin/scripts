#!/bin/sh

CHROOTDIR="/opt/chroot/$2"
if [ "$3" = "" ]; then
    USER=ilya
else
    USER=$3
fi
SHELL='/bin/zsh'
case $1 in
    go)
        mount --bind /home $CHROOTDIR/home
        mount --bind /tmp $CHROOTDIR/tmp
        mount -t proc proc $CHROOTDIR/proc
        mount --bind /dev $CHROOTDIR/dev
        mount -t devpts pts $CHROOTDIR/dev/pts
        mount --bind /sys $CHROOTDIR/sys
        mount --bind /run $CHROOTDIR/run
        cp /etc/resolv.conf $CHROOTDIR/etc/resolv.conf
        chroot $CHROOTDIR /bin/su $USER -c ". /etc/profile;$SHELL"
    ;;
    ungo)
        umount $CHROOTDIR/dev/pts
        for dir in run sys "dev/pts" dev proc tmp home; do
            umount $CHROOTDIR/$dir
        done
    ;;
esac

