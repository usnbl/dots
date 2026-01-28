#!/bin/sh
setxkbmap latam &
/usr/libexec/polkit-gnome-authentication-agent-1 &
pulseaudio --daemonize &
udiskie -a &
