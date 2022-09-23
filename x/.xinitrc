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

# start some nice programs

if [ -d /etc/X11/xinit/xinitrc.d ]; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

autorandr --change # Change monitor layout on new detection of monitor layout

picom --experimental-backends -b

dunst &     # Notifications
udiskie &   # Auto mount removable media
flameshot & # Screenshot tool
redshift &  # Color temperature based on the datetime of your location (https://wiki.archlinux.org/title/redshift)
sxhkd &     # Bind keys

setxkbmap -option caps:escape
setxkbmap us,gr -option grp:win_space_toggle

~/.local/bin/dwm-bar.sh &
~/.local/bin/random-multimonitor-wallpaper.sh

exec dwm
