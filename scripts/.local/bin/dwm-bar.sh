#!/bin/bash

dte() {
	dte="$(date +"%a, %b %d %R")"
	echo "$dte"
}

battery() {
	# local blue=#81A1C1
	get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
	# printf "^c$blue^   $get_capacity"
	# printf '%s' "$get_capacity"
	echo "$get_capacity "
}

status() {
	battery
	dte
}

# TODO: get if audio is muted
# mute_audio() {
#   echo "$"
# }

while true; do
	xsetroot -name "$(status)"
	sleep 30
done
