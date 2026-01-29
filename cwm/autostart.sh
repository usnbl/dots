#!/bin/sh
setxkbmap latam &
feh --bg-fill ~/.wall/a_cartoon_of_a_cat_playing_with_a_ball.png &
picom -b &
/usr/libexec/polkit-gnome-authentication-agent-1 &
pulseaudio --daemonize &
udiskie -a &
