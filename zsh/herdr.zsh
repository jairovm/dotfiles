# Cmd+K integration for Zsh prompts inside Herdr. Ordinary Enter is unchanged.
[[ -o interactive && -n ${HERDR_PANE_ID:-} && ${HERDR_SOCKET_PATH:-} == /* ]] || return 0
[[ $HERDR_PANE_ID != *[^a-zA-Z0-9_:-]* ]] || return 0

zmodload -F zsh/files b:zf_mkdir b:zf_rm || return 1
typeset -g _HERDR_CMDK_DIR="${XDG_CACHE_HOME:-$HOME/.cache}/herdr-keymaps/${HERDR_SOCKET_PATH#/}"
zf_mkdir -p -m 700 -- "$_HERDR_CMDK_DIR" || return 1
typeset -g _HERDR_CMDK_BASE="$_HERDR_CMDK_DIR/$HERDR_PANE_ID"
typeset -gi _HERDR_CMDK_SEQUENCE=0
typeset -g _HERDR_CMDK_TOKEN=''

_herdr_cmdk_line_init() {
  emulate -L zsh
  (( ++_HERDR_CMDK_SEQUENCE ))
  _HERDR_CMDK_TOKEN="$$:$_HERDR_CMDK_SEQUENCE"
  zf_rm -f -- "$_HERDR_CMDK_BASE.request"
  print -r -- "$_HERDR_CMDK_TOKEN" >| "$_HERDR_CMDK_BASE.ready"
}

_herdr_cmdk_line_finish() {
  emulate -L zsh
  zf_rm -f -- "$_HERDR_CMDK_BASE.ready" "$_HERDR_CMDK_BASE.request"
}

_herdr_cmdk_accept_line() {
  emulate -L zsh
  local request=''
  if [[ -f $_HERDR_CMDK_BASE.request ]]; then
    request=$(<"$_HERDR_CMDK_BASE.request")
    zf_rm -f -- "$_HERDR_CMDK_BASE.request"
    if [[ -n $_HERDR_CMDK_TOKEN && $request == $_HERDR_CMDK_TOKEN ]]; then
      # Do not insert text or change BUFFER: preserve the pending command.
      command \clear
      printf '\033[3J'
      zle .reset-prompt
    fi
  fi
  zle .accept-line
}

autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-init _herdr_cmdk_line_init
add-zle-hook-widget line-finish _herdr_cmdk_line_finish
zle -N herdr-cmdk-accept-line _herdr_cmdk_accept_line
bindkey -M emacs '^M' herdr-cmdk-accept-line
bindkey -M viins '^M' herdr-cmdk-accept-line
bindkey -M vicmd '^M' herdr-cmdk-accept-line
