#!/bin/bash

main() {
	local wallpapers
	readarray -t wallpapers < <(find ~/Pictures/Wallpapers/ -type f)

	# echo "${#wallpapers[@]}"
	# local wallpaper = wal
	local random_wallpaper="${wallpapers[1 + $RANDOM % ${#wallpapers[@]}]}"

	feh --bg-fill "$random_wallpaper"
}

main "@"
