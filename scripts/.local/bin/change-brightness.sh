#!/bin/bash

change_brightness() {
	local arguments=$#
	local script=$0
	local kind=$1
	local level=$2

	if [ $arguments -ne 2 ] || [ "$kind" != "A" ] && [ "$kind" != "U" ]; then
		printf "Usage: %s {i,d} volume\n" "$script"
		exit 123
	fi

	brillo -q -"$kind" "$level"

	~/.local/bin/dwm-bar-refresh.sh
}

change_brightness "$@"
