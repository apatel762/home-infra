#!/usr/bin/env bash

# Adding things to PATH, but only if they exist
# https://superuser.com/a/39995
# https://web.archive.org/web/20200930183945/https://superuser.com/questions/39751/add-directory-to-path-if-its-not-already-there

# don't add the folder if it doesn't exist
# or if it's already in the PATH

append_to_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="${PATH:+"$PATH:"}$1"
    fi
}

prepend_to_path() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        PATH="$1${PATH:+":$PATH"}"
    fi
}


# example usage

append_to_path "$HOME/.local/bin"
