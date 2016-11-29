#!/bin/sh

convert -strip -interlace Plane -quality 80 -resize 1500 $1 $1
