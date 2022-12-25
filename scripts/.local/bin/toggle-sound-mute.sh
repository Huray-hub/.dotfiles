#!/bin/bash

toggle_sound_mute() {
	pamixer -t

	~/.local/bin/dwm-bar-refresh.sh
}

toggle_sound_mute
