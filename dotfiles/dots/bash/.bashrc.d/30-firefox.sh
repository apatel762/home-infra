#!/usr/bin/env bash

function __cd_to_firefox_profile_dir() {
    if ! command -v find &>/dev/null; then
        echo "cannot find firefox directory - please install `find`"
    fi
    if ! command -v fzf &>/dev/null; then
        echo "cannot find firefox directory - please install `fzf`"
    fi

    cd "$(find "$HOME/.mozilla/firefox/"*"default"* -maxdepth 0 -type d | fzf)"
}
alias ffp=__cd_to_firefox_profile_dir
