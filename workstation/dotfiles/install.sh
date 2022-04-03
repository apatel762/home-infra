#!/usr/bin/env bash

# -----------------------------------------------
# stuff that has a special folder

mkdir -p ~/.bashrc.d
cp -rvu folder/.bashrc.d/* -t ~/.bashrc.d

mkdir -p ~/.config
cp -vu folder/.inputrc -t ~/.config

# -----------------------------------------------
# stuff to dump in $HOME/

cp -vu folder/.gitconfig -t ~
cp -vu folder/.nbrc -t ~
