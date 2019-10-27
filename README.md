# Dotfiles

## Installation
To install this repo, go to your home directory and do a `git clone`:
```Bash
cd ~
git clone https://github.com/apatel762/dotfiles.git
```

After this, install 'GNU Stow' to easily create symlinks between the required
dotfiles and where they are supposed to be installed.
```Bash
sudo apt install stow
# You'll need to remove any dotfiles that would cause a conflict with
# stow before you perform these commands, or else they wont work.
cd ~/dotfiles
stow bash
stow vim
stow git # etc...
```

### A note about VIM
You will need to install Vundle if you want Vim to not throw errors at you
whenever you try to run it. You may also need to install vim (instead of vi)
if it isn't on your machine.

Do all of this after running `stow vim` to make sure all of these folders are
actually in the right place.
```Bash
sudo apt install vim
cd ~/.vim/bundle/
git clone https://github.com/VundleVim/Vundle.vim.git
```
