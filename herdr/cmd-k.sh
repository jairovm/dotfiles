#!/bin/sh
# Herdr captures the pane ID when the shortcut is pressed.
# Zsh advertises only an active editing prompt. Agents receive plain Enter.
set -eu
pane=${HERDR_ACTIVE_PANE_ID:?Herdr did not provide an active pane}
case "$pane" in *[!a-zA-Z0-9_:-]*|'') exit 1 ;; esac
cache=${XDG_CACHE_HOME:-"$HOME/.cache"}/herdr-keymaps/${HERDR_SOCKET_PATH#/}
request=$cache/$pane.request
token=''
if [ -f "$cache/$pane.ready" ] && IFS= read -r token < "$cache/$pane.ready" && [ -n "$token" ]; then
  (umask 077; printf '%s\n' "$token" > "$request") || exit 1
fi
if "${HERDR_BIN_PATH:-herdr}" pane send-keys "$pane" enter; then
  exit 0
else
  result=$?
  rm -f -- "$request"
  exit "$result"
fi
