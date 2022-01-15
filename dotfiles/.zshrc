export ZSH="/Users/`whoami`/.oh-my-zsh"
plugins=(osx wd python nmap docker cp battery thefuck web-search zsh-autosuggestions)
source ${ZSH}/oh-my-zsh.sh

bindkey -v

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "changyuheng/fz", defer:1
zplug "rupa/z", use:z.sh
zplug "jeffreytse/zsh-vi-mode", defer:2
zplug "zsh-users/zsh-syntax-highlighting", defer:2


zplug load

typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[builtin]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[command]='fg=white,bold'
ZSH_HIGHLIGHT_STYLES[arg0]='fg=white,bold'

if [ -f ~/.aliases ]
then
  source ~/.aliases
fi

if [ -f ~/.env ]
then
  source ~/.env
fi

eval "$(starship init zsh)"
