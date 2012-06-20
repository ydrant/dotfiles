## Command history configuration
HISTFILE=$ZSH/tmp/zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt hist_ignore_dups # ignore duplication command history list
#setopt share_history # share command history data

setopt hist_verify
setopt inc_append_history
#setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_space

#setopt SHARE_HISTORY
setopt APPEND_HISTORY
