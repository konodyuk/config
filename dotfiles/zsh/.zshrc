export ZSH=~/.oh-my-zsh
export ZSH_CUSTOM="$ZSH/custom"

if [[ ! -d $ZSH ]]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git $ZSH
fi

repos=(
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-syntax-highlighting
    jeffreytse/zsh-vi-mode
)  # + zsh-autocomplete?

plugins=()
for repo in $repos; do
    if [[ ! -d $ZSH_CUSTOM/plugins/${repo:t} ]]; then
        git clone https://github.com/${repo} $ZSH_CUSTOM/plugins/${repo:t}
    fi
    plugins+=("${repo:t}")
done
unset repo{s,}

# override keybindings of zsh-vi-mode
function zvm_after_init {
    # ref: https://apple.stackexchange.com/questions/426084/zsh-how-do-i-get-ctrl-p-and-ctrl-n-keys-to-perform-history-search-backward-forw
    bindkey '^P' history-beginning-search-backward
    bindkey '^N' history-beginning-search-forward
    bindkey '^ ' autosuggest-accept
}

source ${ZSH}/oh-my-zsh.sh

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
