#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

# merge in defaults and keymaps
if [ -f $sysresources ]; then
	xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
	xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
	xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
	xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

# runsvdir ~/.runit/runsvdir & # run user services

autorandr --change # Change monitor layout on new detection of monitor layout

picom -b # Window compositor

dunst &     # Notifications
udiskie &   # Auto mount removable media
flameshot & # Screenshot tool
sxhkd &     # Bind keys
# redshift &  # Color temperature based on the datetime of your location
megasync & # Mega cloud sync

setxkbmap -option caps:escape
setxkbmap us,gr -option grp:win_space_toggle

# ~/.local/bin/random-multimonitor-wallpaper.sh
feh --bg-fill --no-fehbg ~/Pictures/Wallpapers/cat-mochiata.png
~/.local/bin/dwm-bar.sh &

exec dwm
# exec dbus-launch --exit-with-session dwm # in order to have a elogind session
