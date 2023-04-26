#!/bin/bash

toggle_sound_mute() {
    wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

	~/.local/bin/dwm-bar-refresh.sh
}

toggle_sound_mute
