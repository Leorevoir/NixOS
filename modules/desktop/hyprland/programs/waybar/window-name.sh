#!/usr/bin/env bash

window_class=$(hyprctl activewindow | grep class | awk '{print $2}')
case $window_class in
  "kitty") echo "kitty " ;;
  "firefox") echo "firefox " ;;
  "discord") echo "discord " ;;
  "spotify") echo "" ;;
  *) echo "$window_class" ;;
esac


