# Dotfiles

## Table of Contents

* [About](#about)
  * [Dependencies](#dependencies)
  * [Installing](#installing)
* [Zed terminal shortcuts](#zed-terminal-shortcuts)
* [Zsh integration](#zsh-integration)
* [Resources](#resources)

## About

### Dependencies

macOS:

```bash
brew install tmux fzf neovim ripgrep ack bc
```

Debian/Ubuntu:

```bash
sudo apt install zsh tmux fzf neovim ripgrep ack bc
```

Install [Oh My Zsh](https://ohmyz.sh/), then its custom plugin and theme:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
git clone https://github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
```

Install [Herdr](https://herdr.dev/docs/install/) to use its configuration.
[Zed](https://zed.dev/) and its keymap are optional.

### Installing

Back up existing configuration files before replacing them with symlinks.

```bash
git clone https://github.com/jairovm/dotfiles.git ~/.dotfiles
mkdir -p ~/.config/zed ~/.config/herdr
ln -nsf ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -nsf ~/.dotfiles/zed/keymap.json ~/.config/zed/keymap.json
ln -nsf ~/.dotfiles/herdr/config.toml ~/.config/herdr/config.toml
```

Only Herdr's configuration file is linked. Its logs and session files remain in
its runtime/configuration directories outside this repository.

### Shell configuration

Back up existing shell files before setting these entry points:

```bash
printf '%s\n' 'source "$HOME/.dotfiles/zsh/env.zsh"' > ~/.zshenv
printf '%s\n' 'source "$HOME/.dotfiles/zsh/profile.zsh"' > ~/.zprofile
printf '%s\n' 'source "$HOME/.dotfiles/zsh/interactive.zsh"' > ~/.zshrc
```

Test a new zsh session before changing the login shell:

```bash
zsh -l
chsh -s "$(command -v zsh)"
```

The shell loads Git aliases, autosuggestions, fzf integration, and Powerlevel10k.
The client terminal needs a Nerd Font for prompt icons, including over SSH.
Homebrew initialization runs only on macOS. Linux uses `C.UTF-8`.

Additional interactive settings load from `~/.config/zsh/local.zsh`; additional
login settings load from `~/.config/zsh/profile.local.zsh`. Both are optional.
An existing `~/.p10k.zsh` overrides the prompt in `zsh/prompt.zsh`.

## Zed terminal shortcuts

Run tmux or Herdr directly in Zed's integrated terminal. Herdr accepts the same
prefix sequences that Zed already sends to tmux, so both can be used in separate
terminals with the same shortcuts.

`Ctrl+H/J/K/L` navigates Zed panes and `Ctrl+\` activates the previous Zed pane.
These bindings are defined in `Workspace` and apply from the terminal too;
they do not need to be repeated in the `Terminal` context. The existing
editor-specific Vim bindings are preserved.

When the terminal is focused:

| Shortcut | Action |
| --- | --- |
| `Ctrl+Shift+H/J/K/L` | Focus a tmux or Herdr pane in that direction |
| `Cmd+D` / `Cmd+Shift+D` | Split right / down |
| `Cmd+T` | Create a tmux window or Herdr tab |
| `Cmd+W` | Close the active multiplexer pane |
| `Ctrl+Tab` / `Ctrl+Shift+Tab` | Next / previous tmux window or Herdr tab |
| `Cmd+1..9` | Select a tmux window or Herdr tab |
| `Ctrl+Cmd+Arrow` | Resize a multiplexer pane |
| `Ctrl+Shift+Left/Right` | Reorder tmux windows or Herdr tabs |
| `Cmd+K` | tmux: clear the screen/history and send Enter; Herdr: clear at a configured Zsh prompt, otherwise send Enter |

Herdr keeps `Ctrl+B` as its prefix. Its `Ctrl+B`, then uppercase `K` binding
runs `herdr/cmd-k.sh`. At a Zsh prompt with the integration loaded, it requests
screen/scrollback clearing and then sends Enter. The pending command is preserved.
Other foreground programs receive plain Enter; no `clear` text is inserted.

After editing Herdr's configuration, reload it from your terminal:

```bash
herdr server reload-config
```

## Zsh integration

The shared shell entry point loads this integration automatically. For a separate
zsh configuration, add the following after Oh My Zsh and other custom settings:

```zsh
[[ ! -r "$HOME/.dotfiles/zsh/herdr.zsh" ]] || source "$HOME/.dotfiles/zsh/herdr.zsh"
```

Open a new Herdr pane after installing this integration. It only activates when
`HERDR_PANE_ID` is set. Ordinary Enter still executes without clearing; `Cmd+K`
clears first, including when the input is empty. Codex/OpenCode keep receiving
Enter with their input unchanged. Shells that have not loaded the integration
also receive plain Enter.

The shell advertises its active editing prompt using small files under
`${XDG_CACHE_HOME:-$HOME/.cache}/herdr-keymaps`. They contain prompt tokens, not
command text. Hooks remove them when leaving the prompt, and reject stale requests.
The shell and Herdr helper must use the same `XDG_CACHE_HOME` value.

The integration uses Zsh's built-in hooks and shell tools; it does not query the
process list or contact external services. Clearing affects terminal output, not
the saved Zsh command history.

Startup keeps PATH and completion directories unique. Homebrew's environment
and rbenv initialization are cached and refreshed when their generators change.
rbenv is initialized only when installed. Run `rbenv rehash` after manually
adding executables to a Ruby installation. Travis completion loads on demand.
Update Oh My Zsh manually with `omz update`.

tmux includes its battery readout on macOS and omits it on Linux. OSC 52 clipboard
writes are forwarded to terminals that support them.

## Resources

- [tmux](https://github.com/tmux/tmux)
- [tmuxline.vim](https://github.com/edkolev/tmuxline.vim)
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
- [Zed key bindings](https://zed.dev/docs/key-bindings)
- [Herdr configuration](https://herdr.dev/docs/configuration/)
