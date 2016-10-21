#!/usr/bin/env python3

# ---- xbright.py ----
# A simple script to fine-tune screen brightness and keyboard backlight
# (c) Ilya Prokin, 2015-10-02
# E.g. usage
# xbright.py scr +5
# xbright.py kbd -10
# To make it work you have to allow yourself run tee on cur_backlight_path without password
# To do so, add following at the end of
# /etc/sudoers
# ------------
# yourusername ALL=NOPASSWD: /usr/bin/tee /sys/class/backlight/intel_backlight/brightness
# yourusername ALL=NOPASSWD: /usr/bin/tee /sys/class/leds/smc\:\:kbd_backlight/brightness
#
# change 'intel_backlight' to your actual path

from subprocess import call, check_output
import sys

# ---- BEGIN CONFIG ----
devices = {
    'scr': {
        'path': '/sys/class/backlight/intel_backlight/',  # screen backlight path
        'minimum': 1,
    },
    'kbd': {
        'path': '/sys/class/leds/smc::kbd_backlight/',  # keyboard backlight path
        'minimum': 0,
    }
}

# ----


def make_cur_backlight_path(base_path):
    return '{0}brightness'.format(base_path)


def make_max_backlight_path(base_path):
    return '{0}max_brightness'.format(base_path)
# ---- END CONFIG ----


def set_new(new, path, minimum, maximum):
    # Check borders
    if new < minimum:
        new = minimum
    elif new > maximum:
        new = maximum
    # Set new value
    exit(call("echo {0} | sudo tee {path}".format(new, path=path), shell=True))

if sys.argv[1] in devices.keys():
    base_path = devices[sys.argv[1]]['path']
    # Make paths
    cur_backlight_path = make_cur_backlight_path(base_path)
    max_backlight_path = make_max_backlight_path(base_path)
    # Load data
    current = int(check_output('cat {0}'.format(cur_backlight_path), shell=True))
    maximum = int(check_output('cat {0}'.format(max_backlight_path), shell=True))
    # Comute new value and set
    if sys.argv[2][0] in ['-', '+']:
        new = current + int(sys.argv[2])
    else:
        new = int(sys.argv[2])
    set_new(new, cur_backlight_path, devices[sys.argv[1]]['minimum'], maximum)
else:
    exit(1)
