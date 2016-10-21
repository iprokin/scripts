#!/bin/sh

#i3-msg workspace 4
#import -window root /tmp/screenshot_for_i3_lock.png
imlib2_grab /tmp/screenshot_for_i3_lock.png
#gm convert /tmp/screenshot_for_i3_lock.png -blur 0x7 /tmp/screenshot_for_i3_lock.png
gm convert /tmp/screenshot_for_i3_lock.png -motion-blur 0x20+45 -implode -0.2 -swirl 180 -blur 0x1 /tmp/screenshot_for_i3_lock.png
i3lock -b -t -i /tmp/screenshot_for_i3_lock.png
rm /tmp/screenshot_for_i3_lock.png
