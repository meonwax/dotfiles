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

# Set wacom options
#xsetwacom --set "Wacom Intuos S Pen stylus" MapToOutput "DVI-0"
#xsetwacom --set "Wacom Intuos S Pad pad" Button 8 "key Shift Pause"
#xsetwacom --set "Wacom Intuos S Pad pad" Button 9 "key Shift Print"
#xsetwacom --set "Wacom Intuos S Pen stylus" Button 2 "button 16"  # disable stylus buttons
#xsetwacom --set "Wacom Intuos S Pen stylus" Button 3 "button 16"  # disable stylus buttons

# Disable mouse thumb buttons by mapping them to 0
xinput set-button-map 8 1 2 3 4 5 6 7 0 0 10 11 12 13 14 15 16

# Disable mouse buttons for page up & down
xinput disable 9

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
exec startxfce4
