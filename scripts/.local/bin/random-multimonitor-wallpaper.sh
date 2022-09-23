#!/bin/bash

main() {
	local wallpapers
	readarray -t wallpapers < <(find ~/Pictures/Wallpapers/ -type f)

	local random_wallpaper="${wallpapers[1 + $RANDOM % ${#wallpapers[@]}]}"

	feh --bg-fill --no-fehbg "$random_wallpaper"
}

main "@"
