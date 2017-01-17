# Dotfiles

## Installation

```
git clone https://github.com/tsandall/dotfiles ~/.dotfiles
ln -s ~/.dotfiles/bashrc ~/.bashrc
ln -s ~/.dotfiles/screenrc ~/.screenrc
ln -s ~/.dotfiles/bashrc ~/.ackrc
ln -s ~/.dotfiles/vimrc ~/.vimrc
ln -s ~/.dotfiles/vim ~/.vim
```

### Vim

Run `vim` and then execute the following command:

```
:PlugInstall
```

> Ignore the "Error detected ... Cannot find color scheme 'grb256'" message on
> first startup. The :PlugInstall command will pull down the color scheme.
