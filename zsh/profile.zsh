source "$HOME/.dotfiles/zsh/env.zsh"

# Initialize Homebrew only on macOS.
if [[ $OSTYPE == darwin* ]]; then
  for _brew_prefix in /opt/homebrew /usr/local; do
    [[ -x $_brew_prefix/bin/brew ]] || continue
    _brew_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh-startup/brew-shellenv.zsh"
    if [[ ! -s $_brew_cache || $_brew_prefix/bin/brew -nt $_brew_cache ||
          $_brew_prefix/Library/Homebrew/cmd/shellenv.sh -nt $_brew_cache ]]; then
      command mkdir -p "${_brew_cache:h}"
      if PATH=/usr/bin:/bin:/usr/sbin:/sbin "$_brew_prefix/bin/brew" shellenv zsh > "$_brew_cache.$$"; then
        command mv -f "$_brew_cache.$$" "$_brew_cache"
      fi
    fi
    if [[ -s $_brew_cache ]]; then
      source "$_brew_cache"
    else
      eval "$("$_brew_prefix/bin/brew" shellenv zsh)"
    fi
    break
  done
  unset _brew_prefix _brew_cache
elif [[ $OSTYPE == linux* ]]; then
  export LANG=C.UTF-8
  export LC_CTYPE=C.UTF-8
fi

[[ ! -r "$HOME/.config/zsh/profile.local.zsh" ]] || source "$HOME/.config/zsh/profile.local.zsh"
