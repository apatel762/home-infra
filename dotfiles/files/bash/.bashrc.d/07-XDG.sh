#!/usr/bin/env bash

export XDG_DATA_HOME="${XDG_DATA_HOME:="$HOME/.local/share"}"
export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:="$HOME/.config"}"
export XDG_STATE_HOME="${XDG_STATE_HOME:="$HOME/.local/state"}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:="$HOME/.cache"}"

# ensure that the folders exist
mkdir -p "$XDG_DATA_HOME"
mkdir -p "$XDG_CONFIG_HOME"
mkdir -p "$XDG_STATE_HOME"
mkdir -p "$XDG_CACHE_HOME"

# ensure that subfolders exist
mkdir -p "$XDG_STATE_HOME"/bash
mkdir -p "$XDG_CONFIG_HOME"/gtk-2.0
mkdir -p "$XDG_STATE_HOME"/less

# ghq get https://github.com/b3nj5m1n/xdg-ninja.git
# ./xdg-ninja.sh

# [android-studio]
export ANDROID_HOME="$XDG_DATA_HOME"/android
# [ansible]
export ANSIBLE_HOME="$XDG_DATA_HOME"/.ansible
# [bash]
export HISTFILE="$XDG_STATE_HOME"/bash/history
# [cargo]
export CARGO_HOME="$XDG_DATA_HOME"/cargo
# [gnupg]
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
# [gtk-2]
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
# [less]
export LESSHISTFILE="$XDG_STATE_HOME"/less/history
# [nb]
export NBRC_PATH="$XDG_CONFIG_HOME/nbrc"
# [nvm]
export NVM_DIR="$XDG_DATA_HOME"/nvm
# [rustup]
export RUSTUP_HOME="$XDG_DATA_HOME"/rustup
# [wget]
alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'