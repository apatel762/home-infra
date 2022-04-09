#!/usr/bin/env bash

# TODO: replace this script with dotbot?
#  https://github.com/anishathalye/dotbot

# -----------------------------------------------
# stuff that has a special folder

mkdir -p ~/.bashrc.d
mkdir -p ~/.config
mkdir -p ~/.config/nvim/

cp -rvu folder/.bashrc.d/* -t ~/.bashrc.d
cp -vu folder/.inputrc -t ~/.config
cp -vu folder/init.vim -t ~/.config/nvim

# -----------------------------------------------
# stuff to dump in $HOME/

cp -vu folder/.gitconfig -t ~
cp -vu folder/.nbrc -t ~
