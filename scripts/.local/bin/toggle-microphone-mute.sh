#!/bin/bash

toggle_microphone_mute() {
    wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle

	~/.local/bin/dwm-bar-refresh.sh
}

toggle_microphone_mute
