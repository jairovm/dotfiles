# Dotfiles

## Table of Contents

* [About](#about)
  * [Dependencies](#dependencies)
  * [Installing](#installing)
* [Zed terminal shortcuts](#zed-terminal-shortcuts)
* [Resources](#resources)

## About

### Dependencies

```bash
brew install tmux
```

Install [Zed](https://zed.dev/) and, to use the Herdr configuration,
[Herdr](https://herdr.dev/docs/install/).

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
| `Cmd+K` | tmux: clear the screen/history and send Enter; Herdr: send Enter only |

Herdr keeps `Ctrl+B` as its prefix. Its `Ctrl+B`, then uppercase `K` binding
forwards Enter to the active pane; it does not clear that pane's scrollback.

After editing Herdr's configuration, reload it from your terminal:

```bash
herdr server reload-config
```

## Resources

- [tmux](https://github.com/tmux/tmux)
- [tmuxline.vim](https://github.com/edkolev/tmuxline.vim)
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
- [Zed key bindings](https://zed.dev/docs/key-bindings)
- [Herdr configuration](https://herdr.dev/docs/configuration/)
