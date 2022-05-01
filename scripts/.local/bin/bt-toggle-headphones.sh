#!/bin/bash

is_bt_device_connected() {
	local deviceInfo=$1

	[[ "$(echo "$deviceInfo" | grep Connected | cut -d ":" -f2)" == " yes" ]] && return 0

	return 1
}

get_device_name() {
	local deviceInfo=$1

	echo "$deviceInfo" | grep Name | cut -d ":" -f2
}

main() {
	local deviceUid=AC:1D:06:41:84:5D
	local deviceInfo
	deviceInfo=$(bluetoothctl info "$deviceUid")

	is_bt_device_connected "$deviceInfo" && action=disconnect || action=connect

	local deviceName
	deviceName=$(get_device_name "$deviceInfo")

	bluetoothctl "$action" "$deviceUid" && notify-send "$deviceName ${action}ed successfully" || notify-send "Could not $action $deviceName " -u critical

	return 0
}

main
