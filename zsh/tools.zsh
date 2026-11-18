# Preserve the generated rbenv shell function without spawning rbenv each time.
if (( $+commands[rbenv] )); then
  _rbenv_executable=${commands[rbenv]:A}
  _rbenv_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh-startup/rbenv-init.zsh"
  if [[ -n ${RBENV_ROOT:-} && $RBENV_ROOT != "$HOME/.rbenv" ]]; then
    eval "$(command rbenv init - --no-rehash zsh)"
  else
    if [[ ! -s $_rbenv_cache || $_rbenv_executable -nt $_rbenv_cache ||
          ${_rbenv_executable:h}/rbenv-init -nt $_rbenv_cache ||
          /usr/lib/rbenv/libexec/rbenv-init -nt $_rbenv_cache ]]; then
      command mkdir -p "${_rbenv_cache:h}"
      if command rbenv init - --no-rehash zsh > "$_rbenv_cache.$$"; then
        command mv -f "$_rbenv_cache.$$" "$_rbenv_cache"
      fi
    fi
    if [[ -s $_rbenv_cache ]]; then
      source "$_rbenv_cache"
    else
      eval "$(command rbenv init - --no-rehash zsh)"
    fi
  fi
  unset _rbenv_executable _rbenv_cache
fi

if (( $+commands[nvim] )); then
  export EDITOR=nvim
else
  export EDITOR=vim
fi

# Older fzf packages ship integration files instead of the --zsh option.
if (( _dotfiles_terminal && $+commands[fzf] )); then
  _fzf_executable=${commands[fzf]:A}
  _fzf_loaded=0
  for _fzf_dir in "${_fzf_executable:h:h}/shell" /usr/share/doc/fzf/examples; do
    [[ -r $_fzf_dir/key-bindings.zsh ]] || continue
    source "$_fzf_dir/key-bindings.zsh"
    [[ ! -r $_fzf_dir/completion.zsh ]] || source "$_fzf_dir/completion.zsh"
    _fzf_loaded=1
    break
  done
  if (( ! _fzf_loaded )); then
    source <(fzf --zsh)
  fi
  unset _fzf_executable _fzf_loaded _fzf_dir
fi

# Avoid parsing the legacy Travis completion on every startup.
if [[ -s "$HOME/.travis/travis.sh" ]]; then
  _travis() {
    unfunction _travis
    source "$HOME/.travis/travis.sh"
    _travis "$@"
  }
  compdef _travis travis
fi
