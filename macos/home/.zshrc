. "$HOME/.local/bin/env"
. "$HOME/.cargo/env"

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

export DYLD_LIBRARY_PATH="/opt/homebrew/opt/zbar/lib:$DYLD_LIBRARY_PATH"

ZSH_THEME="powerlevel10k/powerlevel10k"

zstyle ':omz:update' mode disabled

source $ZSH/oh-my-zsh.sh

alias ls="eza --tree --level=1 --icons=always --no-time --no-user --no-permissions"
alias ls1="eza --tree --level=2 --icons=always --no-time --no-user --no-permissions"
alias ls2="eza --tree --level=3 --icons=always --no-time --no-user --no-permissions"

alias e="exec zsh"
alias c="clear"

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
