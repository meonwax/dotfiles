# vi:syntax=sh

# Check for an interactive session
[ -z "$PS1" ] && return

# Root user
if (($EUID == 0)); then
  PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  # Normal user

  # Powerline shell (not for SSH sessions)
  if [ -z "$SSH_CLIENT" ]; then
    function _update_ps1() {
      PS1=$(powerline-shell $?)
    }
    if [[ $TERM != linux && ! $PROMPT_COMMAND =~ _update_ps1 ]]; then
      PROMPT_COMMAND="_update_ps1; $PROMPT_COMMAND"
    fi
  else
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
  fi

  # Ruby
  if command -v ruby &>/dev/null; then
    export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
    export PATH=${PATH}:${GEM_HOME}/bin
  fi

  export JAVA_HOME=/usr/lib/jvm/default
  export npm_config_prefix=~/.node_modules
  export ANDROID_HOME=~/hdd/android-sdk
  export PYTHONUSERBASE=~/.pip
  export GOPATH=$HOME/workspace/go

  export PATH=${PATH}:~/bin
  export PATH=${PATH}:${npm_config_prefix=}/bin
  export PATH=${PATH}:${ANDROID_HOME}/platform-tools
  export PATH=${PATH}:${ANDROID_HOME}/tools
  export PATH=${PATH}:~/.composer/vendor/bin
  export PATH=${PYTHONUSERBASE}/bin:${PATH}
  export PATH=${PATH}:${GOPATH}/bin
fi

export EDITOR=vim

# Use qt5ct settings for QT5 applications
export QT_QPA_PLATFORMTHEME=qt5ct

# Check the window size after each command and, if necessary, update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Readline
bind 'C-u:kill-whole-line'          # Ctrl-U kills whole line
bind 'set bell-style none'          # No beeping
bind 'set show-all-if-ambiguous on' # Tab once for complete
bind 'set show-all-if-unmodified on'
bind 'set completion-ignore-case on'
bind 'set completion-prefix-display-length 2'
bind 'set completion-map-case on'
bind 'set visible-stats on' # Show file info in complete

# Eternal bash history
export HISTSIZE=-1
export HISTFILESIZE=-1
shopt -s histappend

# Source other dotfiles
[[ -f ~/.bash_functions ]] && . ~/.bash_functions
[[ -f ~/.aliases ]] && . ~/.aliases
[[ -f ~/.bashrc-local ]] && . ~/.bashrc-local

# Autostart X when logged in on tty1
[[ -z $DISPLAY && $XDG_VTNR -eq 1 && $EUID -ne 0 ]] && exec startx
