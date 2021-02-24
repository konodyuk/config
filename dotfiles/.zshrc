export ZSH="/Users/`whoami`/.oh-my-zsh"
plugins=(osx wd python nmap docker cp battery thefuck web-search zsh-autosuggestions)
source ${ZSH}/oh-my-zsh.sh

export ZPLUG_HOME=/usr/local/opt/zplug
source $ZPLUG_HOME/init.zsh

zplug "changyuheng/fz", defer:1
zplug "rupa/z", use:z.sh

zplug load

if [ -f ~/.aliases ]
then
  source ~/.aliases
fi

if [ -f ~/.env ]
then
  source ~/.env
fi

eval "$(starship init zsh)"
