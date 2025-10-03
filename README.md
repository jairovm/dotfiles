# Dotfiles

## Table of Contents

* [About](#about)
  * [Dependencies](#dependencies)
  * [Installing](#installing)
* [Resources](#resources)

## About

### Dependencies
```bash
brew install tmux
```

### Installing

```bash
git clone https://github.com/jairovm/dotfiles.git ~/.dotfiles
ln -nsf ~/.dotfiles/tmux/tmux.conf ~/.tmux.conf
ln -nsf ~/.dotfiles/zed/keymap.json ~/.config/zed/keymap.json
```

### Resources

- [tmux](https://github.com/tmux/tmux)
- [tmuxline.vim](https://github.com/edkolev/tmuxline.vim)
- [vim-tmux-navigator](https://github.com/christoomey/vim-tmux-navigator)
