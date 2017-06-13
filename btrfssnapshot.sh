#!/bin/bash
# Ilya Prokin 2017 - isprokin_(at)_gmail dot com
## Source of inspiration: https://wiki.archlinux.org/index.php/Rsync

## rsync and btrfs-based snapshots
## A folder is copied to "latest" btrfs subvolume with rsync located to external disk.
## Btrfs snapshot is used to backup "latest" subvolume. The result is put to "history/DATETAG" subvolume.
## Run it as root.

BACKUPROOT="/mnt/backup/imcpook" # no trailing slash!
HISTORY="$BACKUPROOT/history"
LATEST="$BACKUPROOT/latest"
LOGFILE="/tmp/rsync_snap_btrfs.log"
# config vars for each profile
case $1 in
    "ilya" | "")
        SRC="/home/ilya/" #dont forget trailing slash!
        SNAP="home/ilya" # no trailing slash!
        EXCLUDES="--exclude-from=/home/ilya/scripts/rsnapshot-ilya-exclude.txt"
        MINCHANGES=30
        ;;
    "etc")
        SRC="/etc/" #dont forget trailing slash!
        SNAP="etc" # no trailing slash!
        EXCLUDES=""
        MINCHANGES=10
        ;;
    "usrlocalbin")
        SRC="/usr/local/bin/" #dont forget trailing slash!
        SNAP="usrlocalbin" # no trailing slash!
        EXCLUDES=""
        MINCHANGES=10
        ;;
esac
# opts
OPTS="-rltgoi --delay-updates --delete $EXCLUDES"
DATEFORMAT="+%Y-%m-%d--%H-%M"

if [ $(ps -ef | grep -v 'sudo' | grep -v 'grep' | grep -v $$ | grep "`basename $0` $1" | wc -l) -gt 0 ]; then
    echo "Another instance is running. Exiting..."
    exit 1
fi

if [ -d "$LATEST/$SNAP" ] ; then

    # run this process with real low priority

    ionice -c 3 -p $$
    renice +12  -p $$

    # sync

    rsync $OPTS $SRC $LATEST/$SNAP/ >> $LOGFILE

    # check if enough has changed and if so
    # make a hardlinked copy named as the date

    COUNT=$( wc -l $LOGFILE | cut -d" " -f1 )
    if [ $COUNT -gt $MINCHANGES ] ; then
        DATETAG=$(date $DATEFORMAT)
        if [ ! -e $HISTORY/$DATETAG ] ; then
            btrfs subvolume create $HISTORY/$DATETAG
            btrfs subvolume snapshot $LATEST/$SNAP $HISTORY/$DATETAG/$(echo $SNAP | sed 's/\//_/g')
            cp $LOGFILE $HISTORY/$DATETAG/
        fi
    fi
    exit 0
else
    echo "Sorry, the backup folder $LATEST/$SNAP not found"
    exit 1
fi
