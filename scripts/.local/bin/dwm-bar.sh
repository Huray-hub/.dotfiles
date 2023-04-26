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

mic() {
	local status
	status="$(wpctl get-volume @DEFAULT_AUDIO_SOURCE@)"
	local volume
	volume=$(printf "%.0f" "$(echo "${status:8:4} * 100" | bc)")

	if [[ $status =~ "MUTED" ]]; then
		printf "^c%s^  %s" "$green" "$volume"
	else
		printf "^c%s^  %s" "$green" "$volume"
	fi
}

volume() {
	local status
	status=$(wpctl get-volume @DEFAULT_AUDIO_SINK@)
	local volume
	volume=$(printf "%.0f" "$(echo "${status:8:4} * 100" | bc)")

	if [[ $status =~ "MUTED" ]]; then
		printf "^c%s^  %s" "$grey" "$volume"
		# printf "^c%s^ 🔇 %s" "$red" "$volume"
	else
		if ((volume == 0)); then
			printf "^c%s^ 🔈 %s" "$red" "$volume"
		elif ((volume < 51)); then
			printf "^c%s^ 奔 %s" "$red" "$volume"
		else
			printf "^c%s^  %s" "$red" "$volume"
		fi
	fi

}

while true; do
	xsetroot -name "$(volume) $(mic) $(battery) $(brightness) $(wlan) $(dte)"
	sleep 30
done
