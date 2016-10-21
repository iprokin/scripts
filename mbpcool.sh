#!/bin/sh

# # mbpcool.sh
#
# A simple shell script to control fan speed on MacBook Pro on linux
# Copyright Ilya Prokin 2016
#
# Without parameters, it adjusts fan speed once.
# This mode is suitable to run with cron.
#
# if called:
# ~~~~~~~~~~~~~~
#   sudo sh mbpcool.sh loop
# ~~~~~~~~~~~~~~
# It will be adjusting fan speed periodically with period INTERVAL.
# This mode is suitable to autorun the script.

# config
# ------

TEMP="/sys/devices/platform/coretemp.0/hwmon/hwmon2/temp1_input"
FAN="/sys/devices/platform/applesmc.768/fan1_min"

RPMMIN=2100
RPMMAX=6200

TMIN=50000  # at 50 deg C fan RPM will be RPMMIN
TMAX=80000  # at 80 deg C fan RPM will be RPMMAX

INTERVAL="40s"

# script
# ------

DT=$(echo $TMAX-$TMIN | bc)

update() {
    T=$(cat $TEMP)
    NEW=$(echo "$RPMMIN + ($RPMMAX-$RPMMIN)*($T-$TMIN)/$DT" | bc)
    #echo $NEW

    if [ "$NEW" -gt $RPMMAX ]; then
        NEW=$RPMMAX
    fi
    echo $NEW > $FAN
}

update

if [ "$1" = "loop" ]; then
    while true
    do
        update
        sleep $INTERVAL
    done
fi

exit 0
