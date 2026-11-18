# Interactive shortcuts and reusable shell helpers.
# This clears terminal output and scrollback, not saved command history.
clear_history() { command clear && printf '\033[3J' }
zle -N clear_history
alias clear=clear_history
bindkey '^ ' autosuggest-accept
bindkey '^K' clear_history

alias gcb='git rev-parse --abbrev-ref HEAD'
alias gbpurge='git branch --merged | grep -v "\*" | grep -v "master" | grep -v "production" | grep -v "stage" | grep -v "staging" | xargs -n 1 git branch -d'
alias utc='ruby -e "puts Time.now.utc"'
alias sr="ruby -r securerandom -e 'puts [%w[! # \$ %].sample, SecureRandom.hex(15).sub(/[a-z]{2}/) { |c| c.upcase }].join'"

if (( $+commands[kubectl] )); then
  kubectl() {
    if [[ -f kubeconfig ]]; then
      command kubectl --kubeconfig=kubeconfig "$@"
    else
      command kubectl "$@"
    fi
  }
fi
