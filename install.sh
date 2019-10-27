#!/bin/bash

echo "Installing packages... (you may need to enter your password)"
sudo apt-get install \
  stow \
  vim neovim \
  python python3

echo ""
echo "Preparing to symlink dotfiles, this will delete your current dotfiles."
echo "Would you like to continue?"
select yn in Yes No
do
  case $yn in
    Yes)
      # dotfiles to delete
      declare -a FILES=(
        .bashrc
        .inputrc
        .gitconfig
        .vimrc
      )

      # loop over above list and delete files
      for FILE in ${FILES[@]}; do
        [ -f $HOME/$FILE ] && echo "* Deleting existing $FILE" && sudo rm $HOME/$FILE
      done

      break;
      ;;
    No)
      echo ""
      echo "Aborting..."
      exit 0
      ;;
  esac
done

echo ""
echo "Creating symlinks..."
echo "stow bash" && stow bash
echo "stow nvim" && stow nvim
echo "stow other" && stow other
echo "stow vim" && stow vim

echo ""
if [[ -d $HOME/.vim/bundle/Vundle.vim ]]; then
  echo "Vundle.vim already installed - skipping..."
else
  echo "Installing Vundle.vim for vim"

  # make the bundle dir if it doesn't exist already
  if [[ ! -d $HOME/.vim/bundle ]]; then
    mkdir $HOME/.vim/bundle/
  fi

  cd $HOME/.vim/bundle && git clone https://github.com/VundleVim/Vundle.vim.git
fi

echo ""
echo "Automatic installation steps complete!"

echo ""
echo "Remaining work:"
echo "* Enter vim (type 'vim') and do :PluginUpdate"
echo "* Enter neovim (type 'nvim') and do :UpdateRemotePlugins"
