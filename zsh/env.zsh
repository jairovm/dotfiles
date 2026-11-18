# Minimal PATH setup, including non-interactive SSH commands.
typeset -gU path PATH fpath FPATH

# Normalize inherited server settings before any shell helper starts.
if [[ $OSTYPE == linux* ]]; then
  export LANG=C.UTF-8
  export LC_CTYPE=C.UTF-8
  export SHELL=${commands[zsh]}
fi

for _dotfiles_bin in "$HOME/.local/bin" "$HOME/bin" "$HOME/.cargo/bin"; do
  [[ ! -d $_dotfiles_bin ]] || path=("$_dotfiles_bin" $path)
done
unset _dotfiles_bin
