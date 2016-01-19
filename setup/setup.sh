#!/bin/sh

# Check for sudo
if (( $EUID != 0 )); then
    if !( which sudo &> /dev/null ); then
        echo "Please install sudo or run this script as root."
        exit
    fi
fi

# Install packages
if grep -qi "arch linux" /etc/issue; then
    echo "Arch Linux detected. Installing packages..."
    DIR=$(dirname $0)
    if (( $EUID != 0 )); then
        sudo pacman -Sy $(<$DIR/arch-packages)
    else
        pacman -Sy $(<$DIR/arch-packages)
    fi
fi

DOTFILE_DIR=~/dotfiles                   # dotfiles directory
BACKUP_DIR=~/dotfiles_backup             # old dotfiles backup directory

# Create backup in home directory
echo "Creating $BACKUP_DIR for backup of any existing dotfiles in ~"
mkdir -p $BACKUP_DIR

for file in $(ls -p $DOTFILE_DIR | grep -v /); do
    if [ -f ~/.$file ] && ! [ -L ~/.$file ]; then
        # Move any existing dotfiles in home directory to backup directory
        mv ~/.$file $BACKUP_DIR
    fi

    # Then (re)create symbolic links
    if [ -L ~/.$file ]; then
        rm ~/.$file
    fi
    ln -s $DOTFILE_DIR/$file ~/.$file
done

echo "Done."
