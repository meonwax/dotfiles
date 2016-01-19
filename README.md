# My personal configuration files

These files should work on all major Linux distributions as long as the required packages are installed.

## Setup

    # Clone repository
    git clone https://github.com/meonwax/dotfiles.git
    
    # Run setup script
    dotfiles/setup/setup.sh

All config files will be symlinked from home directory to the repository location.  
Possibly existing files will be copied to `~/dotfiles_backup/`.

    # List backed up files
    ls -la ~/dotfiles_backup/

## Inspired by

- https://bbs.archlinux.org/viewtopic.php?id=41331
- http://blog.smalleycreative.com/tutorials/using-git-and-github-to-manage-your-dotfiles
- https://github.com/blinry/dotfiles
- https://github.com/xero/dotfiles
