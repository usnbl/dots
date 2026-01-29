#!/bin/sh
setxkbmap latam &
feh --bg-fill ~/.wall/959202.jpg
picom -b &
/usr/libexec/polkit-gnome-authentication-agent-1 &
pulseaudio --daemonize &
udiskie -a &
