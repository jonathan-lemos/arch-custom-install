#!/bin/bash

BAR_HEIGHT=30
TMPFILE="/tmp/magicktmp"

if [[ -z $1 ]]; then
	echo "Usage: $0 <image>"
	exit
fi

if ! hash magick 2>/dev/null; then
	echo "Imagemagick is not installed"
	exit
fi

FILETYPE=$(echo $1 | sed -re 's/[^\.]*\.(.+)/\1/g')
WIDTH=$(magick identify $1 | awk '{print $3}' | sed -re 's/([0-9]+)x[0-9]+/\1/g')

convert $1 -resize 1x1 $TMPFILE.$FILETYPE
convert $TMPFILE.$FILETYPE $TMPFILE.txt
RGB=$(cat $TMPFILE.txt | awk 'FNR==2{print $3}')
RED=$(echo $RGB | sed -re 's/#([0-9A-F]{2}).+/\1/g')
GREEN=$(echo $RGB | sed -re 's/#.{2}([0-9A-F]{2}).+/\1/g')
BLUE=$(echo $RGB | sed -re 's/#.{4}([0-9A-F]{2}).*/\1/g')
REDDEC=$((16#$RED))
GREENDEC=$((16#$GREEN))
BLUEDEC=$((16#$BLUE))
BRIGHTNESS=$(($REDDEC + $GREENDEC + $BLUEDEC))

rm ${TMPFILE}*

sed -i -re 's/^background = .+/background = #BB'"$RED$GREEN$BLUE"'/g' ~/.config/polybar/config

if [[ $BRIGHTNESS -gt 384 ]]; then
	sed -i -re 's/^foreground = .+/foreground = #333333/g' ~/.config/polybar/config

	sed -i -re 's/^foreground-alt = .+/foreground-alt = #555/g' ~/.config/polybar/config

else
	sed -i -re 's/^foreground = .+/foreground = #dddddd/g' ~/.config/polybar/config

	sed -i -re 's/^foreground-alt = .+/foreground-alt = #bbb/g' ~/.config/polybar/config
fi
