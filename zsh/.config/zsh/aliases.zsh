#! /bin/zsh

alias configGit="/usr/bin/git --git-dir=$HOME/dotfiles/ --work-tree=$HOME"
alias configAdd="$HOME/skripts/commitAndPushConfig.sh"
alias vim="/usr/bin/nvim"
alias goalEdit="$HOME/skripts/modifyPersonalGoals.sh"
alias config="$HOME/.config"
alias wallpapers="$HOME/Wallpapers"

# Changing ls to exa
alias ls='exa -laG  --group-directories-first'
alias la='exa -a --group-directories-first'
alias ll='exa -lG --group-directories-first'
