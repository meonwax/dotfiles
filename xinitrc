#!/bin/sh
#
# ~/.xinitrc
#
# Executed by startx

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/*; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# Set screen timeout
xset dpms 300 300 300

# Auto lock screen
#xautolock -time 15 -locker slock &

# Load xkb keymap
test -f ~/.keymap.xkb && xkbcomp -w 0 ~/.keymap.xkb $DISPLAY

# Activate numlock
numlockx on

# Finally start DE/WM
export DE=xfce
exec startxfce4
