#!/bin/sh

MAINMON='LVDS1'
EXTMON='DP1'
WHERE='above'

xSTATUS=`xrandr | grep "$EXTMON connected"`
if [ "$xSTATUS" != "" ]; then
    if echo $xSTATUS | grep -qE '[0-9]+x[0-9]+'; then
        xrandr --output $EXTMON --off
    else
        xrandr --output $MAINMON --auto --primary --output $EXTMON --auto --$WHERE $MAINMON
    fi
else
    xrandr --output $EXTMON --off
fi 

if pgrep i3; then
    i3-msg restart
else
    ~/.fehbg
fi
