#!/usr/bin/env bash

# refresh bash
alias bp='echo "source ~/.bashrc" && source ~/.bashrc'

# detailed ls
alias ll='ls -l --all --classify --human-readable'

alias vimrc='$EDITOR $HOME/.vimrc'          # edit vimrc
alias bashrc='$EDITOR $HOME/.bashrc'        # edit bashrc
alias gitconfig='$EDITOR $HOME/.gitconfig'  # edit gitconfig

# open stuff from terminal easily
if command -v xdg-open &>/dev/null; then
    alias open='xdg-open'
fi

# ----------------------------------------------------------------------
# zip utils

# loops through every folder in the current dir and zips them up
alias zipall='for i in */; do zip -r "${i%/}.zip" "$i"; done'

# desc: extract an archive using one of many different archive commands
# args: $1 = the path to the archive to extract
ex()
{
    if [ -f "$1" ] ; then
        case "$1" in
            *.tar.bz2)   ( set -x; tar xjf "$1"    ) ;;
            *.tar.gz)    ( set -x; tar xzf "$1"    ) ;;
            *.bz2)       ( set -x; bunzip2 "$1"    ) ;;
            *.rar)       ( set -x; unrar x "$1"    ) ;;
            *.gz)        ( set -x; gunzip "$1"     ) ;;
            *.tar)       ( set -x; tar xf "$1"     ) ;;
            *.tbz2)      ( set -x; tar xjf "$1"    ) ;;
            *.tgz)       ( set -x; tar xzf "$1"    ) ;;
            *.zip)       ( set -x; unzip "$1"      ) ;;
            *.cbz)       ( set -x; unzip "$1"      ) ;;
            *.Z)         ( set -x; uncompress "$1" ) ;;
            *.7z)        ( set -x; 7za x "$1"      ) ;;
            *.deb)       ( set -x; ar x "$1"       ) ;;
            *.tar.xz)    ( set -x; tar xf "$1"     ) ;;
            *.tar.zst)   ( set -x; unzstd "$1"     ) ;;
            *)           echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}
