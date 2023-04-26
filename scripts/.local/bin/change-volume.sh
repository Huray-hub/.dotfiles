#!/bin/bash

change-volume() {
	local arguments=$#
	local script=$0
	local value=$1

	if [ $arguments -ne 1 ]; then
		printf "Usage: %s number%s{+,-}\n" "$script" "%"
		exit 123
	fi

	wpctl set-volume @DEFAULT_AUDIO_SINK@ "$value"

	~/.local/bin/dwm-bar-refresh.sh
}

change-volume "$@"
