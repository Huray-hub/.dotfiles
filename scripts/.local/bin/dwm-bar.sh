#!/bin/bash

black=#1e222a
green=#7eca9c
# white=#abb2bf
grey=#808080
blue=#7aa2f7
red=#d47d85
darkblue=#668ee3
yellow=#E0AF68

dte() {
	local dte
	dte=$(date +"%a, %b %d %R")

	printf "^c%s^ ^b%s^  " "$black" "$darkblue"
	printf "^c%s^^b%s^ %s " "$black" "$blue" "$dte"
}

battery() {
	local capacity
	capacity="$(cat /sys/class/power_supply/BAT0/capacity)"

	printf "^c%s^  %s" "$blue" "$capacity"
}

# 
wlan() {
	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
	up) printf "^c%s^ ^b%s^ 󰤨 ^d^%s" "$black" "$blue" " ^c$blue^Connected" ;;
	down) printf "^c%s^ ^b%s^ 󰤭 ^d^%s" "$black" "$blue" " ^c$blue^Disconnected" ;;
	esac
}

# wlan() {
# 	case "$(cat /sys/class/net/wl*/operstate 2>/dev/null)" in
# 	# up) printf "^c%s^ ^b%s^ 󰤨 ^d^" "$black" "$blue"  ;;
# 	up) printf "^c%s^ 󰤨" "$green" ;;
# 	down) printf "^c%s^ 󰤭" "$green" ;;
# 	esac
# }

brightness() {
	printf "^c%s^  " "$yellow"
	printf "^c%s^%.0f\n" "$yellow" "$(brillo -G)"
}

# TODO: monitor if mic is muted
mic() {
	status="$(cat /sys/class/leds/hda::micmute/brightness)"

	case $status in
	0)
		echo -e "^c$green^" "$"
		;;
	*)
		echo -e "^c$grey^"
		;;
	esac
}

volume() {
	local status
	status=$(pamixer --get-mute)
	local volume
	volume=$(pamixer --get-volume)

	if [ "$status" == "true" ]; then
		printf "^c%s^  %s" "$grey" "$volume"
	else
		if [ "$volume" -eq 0 ]; then
			printf "^c%s^ 🔈 %s" "$red" "$volume"
		elif [ "$volume" -le 50 ]; then
			printf "^c%s^ 奔 %s" "$red" "$volume"
		else
			printf "^c%s^  %s" "$red" "$volume"
		fi
	fi

}

while true; do
	xsetroot -name "$(volume) $(battery) $(brightness) $(wlan) $(dte)"
	sleep 30
done
