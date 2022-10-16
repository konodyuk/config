# clone a plugin, identify its init file, source it, and add it to fpath
# ref: https://github.com/mattmc3/zsh_unplugged
function plugin-load {
  local repo plugdir initfile
  ZPLUGINDIR=${ZPLUGINDIR:-${ZDOTDIR:-$HOME/.config/zsh}/plugins}
  for repo in $@; do
    plugdir=$ZPLUGINDIR/${repo:t}
    initfile=$plugdir/${repo:t}.plugin.zsh
    if [[ ! -d $plugdir ]]; then
      echo "Cloning $repo..."
      git clone -q --depth 1 --recursive --shallow-submodules https://github.com/$repo $plugdir
    fi
    if [[ ! -e $initfile ]]; then
      local -a initfiles=($plugdir/*.plugin.{z,}sh(N) $plugdir/*.{z,}sh{-theme,}(N))
      (( $#initfiles )) || { echo >&2 "No init file found '$repo'." && continue }
      ln -sf "${initfiles[1]}" "$initfile"
    fi
    fpath+=$plugdir
    (( $+functions[zsh-defer] )) && zsh-defer . $initfile || . $initfile
  done
}

repos=(
    zsh-users/zsh-autosuggestions
    zsh-users/zsh-syntax-highlighting
    jeffreytse/zsh-vi-mode
)  # + zsh-autocomplete?

# override keybindings of zsh-vi-mode
function zvm_after_init {
    # ref: https://apple.stackexchange.com/questions/426084/zsh-how-do-i-get-ctrl-p-and-ctrl-n-keys-to-perform-history-search-backward-forw
    bindkey '^P' history-beginning-search-backward
    bindkey '^N' history-beginning-search-forward
}

plugin-load $repos

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
