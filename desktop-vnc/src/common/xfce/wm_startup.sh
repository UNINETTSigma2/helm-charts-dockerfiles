#!/usr/bin/env bash
### every exit != 0 fails the script
set -e

echo -e "\n------------------ startup of Xfce4 window manager ------------------"

# disable screensaver and power management
xset -dpms &
xset s noblank &
xset s off &

(
  while true; do
    /usr/bin/startxfce4 --replace > $HOME/wm.log
    sleep 1
  done
) &

cat $HOME/wm.log
