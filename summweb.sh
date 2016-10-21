#!/bin/sh
curl -L "$1" | html2text | ots stdin
