#!/bin/zsh
xsetroot -cursor_name left_ptr
setbg ~/Pictures/Wallpapers/old_computer-wallpaper-1920x1080.jpg&
mpdas &
xset b off
status|bar -p&
export HOME=/Users/youri
urxvtd -q -o -f
urxvtc&
2bwm
