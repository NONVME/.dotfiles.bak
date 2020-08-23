#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done
export MONITORLaptop=$(xrandr -q | polybar -m|grep "eDP1" |cut -d: -f1)
export MONITORDesktop=$(xrandr -q | polybar -m|grep "HDMI1" |cut -d: -f1)

if [ "$MONITORLaptop" = "eDP1" ]
then
	polybar laptop -c $HOME/.config/polybar/config_laptop.ini &
fi

if [ "$MONITORDesktop" = "HDMI1" ]
then
	polybar desktop -c $HOME/.config/polybar/config_desktop.ini &
fi
