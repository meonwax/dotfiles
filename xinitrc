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
xset s off dpms 600 600 600

# Auto lock screen
#xautolock -time 15 -locker slock &

# Disable insert key
xmodmap -e 'keycode 118 = '

# Disable CapsLock
xmodmap -e 'keycode 66 = '

# Activate numlock
numlockx on

# Finally start DE/WM
export DE=xfce
exec startxfce4
