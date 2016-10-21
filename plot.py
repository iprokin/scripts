#!/bin/env python3

"""
 plot.py : Plot Matplotlib Graphs from Commandline

 Copyright Ilya Prokin 2016

A simple script to plot from data stdin or
from file when filename is gived as
first positional argument.
Default delimiter is space.

Example:
    cat ~/Sync/Exp_data_PhD/STDP-pairings.csv | tr ',' ' ' | python3 plot.py
    cat ~/Sync/Exp_data_PhD/STDP-pairings.csv | python3 plot.py -d ,
    python3 plot.py ~/Sync/Exp_data_PhD/STDP-pairings.csv -d ,
"""
import sys
import matplotlib.pylab as plt
import csv

def tofloat(el, fill=float('nan')):
    try:
        return float(el)
    except:
        return fill

dkey = '-d'
with open(sys.argv[1], 'r') if len(sys.argv) > 1 and sys.argv[1] != dkey else sys.stdin as f:
    d = ' '
    if len(sys.argv) > 1:
        if dkey in sys.argv:
            d = sys.argv[sys.argv.index(dkey) + 1]
    ss = list(zip(*[tuple(map(tofloat, row)) for row in csv.reader(f, delimiter=d, quotechar='|')]))
    #ss = f.readlines()

for s in ss:
    plt.plot(s, ':o')
plt.show()
