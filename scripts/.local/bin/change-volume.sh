#!/bin/bash

change-volume() {
	local arguments=$#
	local script=$0
	local kind=$1
	local volume=$2

	if [ $arguments -ne 2 ] || [ "$kind" != "i" ] && [ "$kind" != "d" ]; then
		printf "Usage: %s {i,d} volume\n" "$script"
		exit 123
	fi

	pamixer -"$kind" "$volume"

	~/.local/bin/dwm-bar-refresh.sh
}

change-volume "$@"
