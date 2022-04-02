#!/usr/bin/env bash

# bash config
mkdir -p ~/.bashrc.d
cp -rvu folder/.bashrc.d/* -t ~/.bashrc.d

# git config
cp -vu folder/.gitconfig -t ~

# inputrc
mkdir -p ~/.config
cp -vu folder/.inputrc -t ~/.config