# Minimal PATH setup, including non-interactive SSH commands.
typeset -gU path PATH fpath FPATH
for _dotfiles_bin in "$HOME/.local/bin" "$HOME/bin" "$HOME/.cargo/bin"; do
  [[ ! -d $_dotfiles_bin ]] || path=("$_dotfiles_bin" $path)
done
unset _dotfiles_bin
