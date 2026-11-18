[[ -o interactive ]] || return
source "$HOME/.dotfiles/zsh/env.zsh"

# Instant prompt redirects descriptors, so capture TTY status before sourcing it.
typeset -gi _dotfiles_terminal=0
[[ ! -t 0 || ! -t 1 ]] || _dotfiles_terminal=1
if (( _dotfiles_terminal )) && [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
zstyle ':omz:update' mode disabled
ZSH_THEME=''
(( ! _dotfiles_terminal )) || ZSH_THEME=powerlevel10k/powerlevel10k
plugins=(git zsh-autosuggestions)
source "$ZSH/oh-my-zsh.sh"

if (( _dotfiles_terminal )); then
  # Prefer an existing local prompt override.
  if [[ -r "$HOME/.p10k.zsh" ]]; then
    source "$HOME/.p10k.zsh"
  else
    source "$HOME/.dotfiles/zsh/prompt.zsh"
  fi
fi
source "$HOME/.dotfiles/zsh/tools.zsh"
source "$HOME/.dotfiles/zsh/aliases.zsh"
[[ ! -r "$HOME/.config/zsh/local.zsh" ]] || source "$HOME/.config/zsh/local.zsh"
source "$HOME/.dotfiles/zsh/herdr.zsh"
unset _dotfiles_terminal
