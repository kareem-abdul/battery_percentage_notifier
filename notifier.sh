#!/bin/bash

MAX_PERCENTAGE=80
MIN_PERCENTAGE=20

main() {
	while true
	do
		local info=$(upower -i $(upower -e | grep 'BAT'))
		local state=$(grep "state" <<< $info | sed -E 's/.*\s(\w+?)/\1/g')
		local percentage=$(grep "percentage" <<< $info | sed -E 's/.*?\s([0-9]+?)%/\1/g')
		if [ "$state" = "charging" ]
		then
			if [ $percentage -gt $MAX_PERCENTAGE ] 
			then
				notify-send -t 1000 -u critical "Battery above $MAX_PERCENTAGE%" "Chargin: $percentage%"
				paplay /usr/share/sounds/freedesktop/stereo/bell.oga
			fi
		elif [ "$state" = "discharging" ]
		then
			if [ $percentage -lt $MIN_PERCENTAGE ]
			then
				notify-send "Battery bellow $MIN_PERCENTAGE%!" "discharging: $percentage%"
				paplay /usr/share/sounds/freedesktop/stereo/bell.oga
			fi
		fi
		sleep 240
	done

}

main
