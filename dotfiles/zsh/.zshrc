export ZSH=~/.oh-my-zsh

if [[ ! -e  $ZSH/custom/plugins/zsh-autosuggestions ]]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions $ZSH/custom/plugins/zsh-autosuggestions
fi

if [[ ! -e  $ZSH/custom/plugins/zsh-syntax-highlighting ]]; then
    git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting $ZSH/custom/plugins/zsh-syntax-highlighting
fi

if [[ ! -e  $ZSH/custom/plugins/zsh-vi-mode ]]; then
    git clone --depth=1 https://github.com/jeffreytse/zsh-vi-mode $ZSH/custom/plugins/zsh-vi-mode
fi

plugins=(zsh-autosuggestions zsh-vi-mode zsh-syntax-highlighting)  # + zsh-autocomplete?
source ${ZSH}/oh-my-zsh.sh

bindkey -v

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

export PATH="$HOME/config/bin:$PATH"

eval "$(zoxide init zsh)"
eval "$(starship init zsh)"
