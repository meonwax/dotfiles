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

# Restore alsa mixer state
alsactl -f /var/lib/alsa/asound.state restore

# Disable insert key
xmodmap -e 'keycode 118 = '

# Disable CapsLock
xmodmap -e 'keycode 66 = '

# Activate numlock
numlockx on

# Dual monitor setup for radeon
#xrandr --output DVI-0 --auto --output DVI-1 --auto --right-of DVI-0

# Automaticaly lock screen after 15 minutes inactivity and turn off monitors
xautolock -time 15 -locker slock &
xset s 900 900

# Finally start DE/WM
export DE=xfce
exec startxfce4
