setxkbmap us -variant colemak
setxkbmap -option terminate:ctrl_alt_bksp
setxkbmap -option lv3:ralt_switch
xmodmap ~/.Xmodmap
xset r 66
xset b off
xsetroot -bg \#333 -fg \#121212 -mod 10 3
xsetroot -cursor_name left_ptr
urxvtd -q -o -f
urxvtc&
xset r 66
2bwm
