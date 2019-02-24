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
stow bash
stow vim
stow git # etc...
```
