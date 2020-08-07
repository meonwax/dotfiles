# vi:syntax=sh

# Check for an interactive session
[ -z "$PS1" ] && return

# Root user
if (( $EUID == 0 )); then
  PS1='\[\033[01;31m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
  # Normal user

  # Kubernetes prompt
  source '/opt/kube-ps1/kube-ps1.sh'
  export KUBE_PS1_NS_ENABLE=false
  export KUBE_PS1_SYMBOL_ENABLE=false
  export KUBE_PS1_CTX_COLOR=magenta

  # Enable Git prompt script
  if [ -f /usr/share/git/completion/git-prompt.sh ]; then
    source /usr/share/git/completion/git-prompt.sh
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[1;92m\]$(__git_ps1 " (%s)")\[\033[0m\]$(kube_ps1) $ '
    # Set extra details for the Git prompt
    export GIT_PS1_SHOWDIRTYSTATE=1
    export GIT_PS1_SHOWSTASHSTATE=1
    export GIT_PS1_SHOWUNTRACKEDFILES=1
    export GIT_PS1_SHOWUPSTREAM=auto
  else
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]$(kube_ps1) $ '
  fi

  # Travis CI Client
  [[ -f ~/.travis/travis.sh ]] && source ~/.travis/travis.sh

  export JAVA_HOME=/usr/lib/jvm/default
  export GEM_HOME=$(ruby -e 'puts Gem.user_dir')
  export npm_config_prefix=~/.node_modules
  export ANDROID_HOME=~/hdd/android-sdk
  export PYTHONUSERBASE=~/.pip
  export GOPATH=$HOME/workspace/go

  export PATH=${PATH}:~/bin
  export PATH=${PATH}:${GEM_HOME}/bin
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
bind 'C-u:kill-whole-line'             # Ctrl-U kills whole line
bind 'set bell-style none'             # No beeping
bind 'set show-all-if-ambiguous on'    # Tab once for complete
bind 'set show-all-if-unmodified on'
bind 'set completion-ignore-case on'
bind 'set completion-prefix-display-length 2'
bind 'set completion-map-case on'
bind 'set visible-stats on'            # Show file info in complete

# History size
export HISTSIZE=-1
export HISTFILESIZE=4096

# Source other dotfiles
[[ -f ~/.bash_functions ]] && . ~/.bash_functions
[[ -f ~/.aliases ]] && . ~/.aliases
[[ -f ~/.bashrc-local ]] && . ~/.bashrc-local

# Autostart X when logged in on tty1
[[ -z $DISPLAY && $XDG_VTNR -eq 1 && $EUID -ne 0 ]] && exec startx
