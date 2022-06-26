#!/bin/bash

if [ -z $MAX_PERCENTAGE ]; then
	MAX_PERCENTAGE=80;
fi
SOUND='/usr/share/sounds/freedesktop/stereo/bell.oga'

main() {
	local info=`upower -i $(upower -e | grep 'BAT' | head -n 1)`;
	local state=`grep state <<< $info | cut -d: -f2 | tr -d ' '`;
	local percentage=`grep percentage <<< $info | cut -d: -f2 | tr -d ' ' | cut -d% -f1`;

	if [ "$state" = "charging" ]; then
		[ $percentage -gt $MAX_PERCENTAGE ] && { notify-send -a "Battery Percentage" "Batter above $MAX_PERCENTAGE%";  paplay $SOUND;  }
	fi
}

main
