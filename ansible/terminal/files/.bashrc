# shellcheck source=/dev/null

#       _                     _                   
#      | |                   | |                  
#      | |__     __ _   ___  | |__    _ __    ___ 
#      | '_ \   / _` | / __| | '_ \  | '__|  / __|
#   _  | |_) | | (_| | \__ \ | | | | | |    | (__ 
#  (_) |_.__/   \__,_| |___/ |_| |_| |_|     \___|
#  _______________________________________________
#                                                 

# Using https://www.messletters.com/en/big-text/ for the above text.
# Fonts used:
# - Standard (for the above)
# - ogre (for the other titles)

# ----------------------------------------------------------------------
# TABLE OF CONTENTS
# ----------------------------------------------------------------------

# In Vim, press * on the below words to go to the section that they
# refer to:
#
#   1_Defaults
#   2_Prompt
#   3_Aliases
#

# ----------------------------------------------------------------------

#     ___         __                _  _        
#    /   \  ___  / _|  __ _  _   _ | || |_  ___ 
#   / /\ / / _ \| |_  / _` || | | || || __|/ __|
#  / /_// |  __/|  _|| (_| || |_| || || |_ \__ \
# /___,'   \___||_|   \__,_| \__,_||_| \__||___/
#                                               

# 1_Defaults

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
    *) return;;
esac

# ----------------------------------------------------------------------
# bash history
# see the `bash` manpage for more info

HISTCONTROL=ignoreboth:erasedups
HISTSIZE=1000
HISTFILESIZE=2000

# ----------------------------------------------------------------------
# shell options

shopt -s histappend         # append to history instead of deleting
shopt -s checkwinsize       # checks term size when bash regains control
shopt -s expand_aliases     # expand aliases
shopt -s cmdhist            # save multiline cmds as single line in hist

# ----------------------------------------------------------------------
# shell completions and colours

# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        source /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        source /etc/bash_completion
    fi
fi

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    if test -r ~/.dircolors;
    then
        eval "$(dircolors -b ~/.dircolors)"
    else
        eval "$(dircolors -b)"
    fi

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# ----------------------------------------------------------------------

#    ___                                 _   
#   / _ \ _ __   ___   _ __ ___   _ __  | |_ 
#  / /_)/| '__| / _ \ | '_ ` _ \ | '_ \ | __|
# / ___/ | |   | (_) || | | | | || |_) || |_ 
# \/     |_|    \___/ |_| |_| |_|| .__/  \__|
#                                |_|         

# 2_Prompt

# shellcheck disable=SC2034
BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
# shellcheck disable=SC2034
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
DIM=$(tput dim)
RESET_COLOURS=$(tput sgr0)

# a function that gets the point-to-point network interface id so that
# we can see if we're on a vpn or not (and which adapter we're using)
function __vpn_info() {
    if [ -n "$(ifconfig -s | egrep "ppp[0-9]")" ]; then
        echo -n "/""$(ifconfig -s | egrep "ppp[0-9]" | awk '{print $1}')"
    elif [ -n "$(ifconfig -s | egrep "tun[0-9]")" ]; then
        echo -n "/""$(ifconfig -s | egrep "tun[0-9]" | awk '{print $1}')"
    #else
    #    echo -n "/""$(ifconfig -s | egrep "wlp" | awk '{print $1}')"
    fi
}

# a function to get the short path of some directory, so it doesn't take
# up a lot of space on the screen
function __shortpath() {
    full_dir=$(pwd | sed -e "s!^${HOME}!~!")
    if [[ "$full_dir" == "~" ]]; then
        echo -n "$full_dir"
    else
        # Replace (/.) with (/..) for 2 chars, etc
        front=$(echo "${full_dir%/*}" | sed -re 's!(/.)[^/]*!\1!g')
        back=${full_dir##*/}
        echo -n "${front}/${back}"
    fi
}

function __gitinfo() {
    # Get the current git branch and colorize to indicate branch state
    # branch_name+ indicates there are stash(es)
    # branch_name? indicates there are untracked files
    # branch_name! indicates your branch has diverged
    # branch_name> indicates your branch is ahead
    # branch_name< indicates your branch is behind
    local unknown untracked stash clean ahead behind staged dirty diverged
    unknown=$BLUE        # blue
    untracked=$GREEN     # green
    stash=$GREEN         # green
    clean=$GREEN         # green
    ahead=$YELLOW        # yellow
    behind=$YELLOW       # yellow
    staged=$CYAN         # cyan
    dirty=$RED           # red
    diverged=$RED        # red
    branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
    extra_info=""
    if [[ -n "$branch" ]]; then
        git_status=$(git status 2> /dev/null)
        # If nothing changes the BRANCH_COLOUR, we can spot unhandled cases.
        BRANCH_COLOUR=$unknown
        if [[ $git_status =~ 'Untracked files' ]]; then
            BRANCH_COLOUR=$untracked
            extra_info="${extra_info}?"
        fi
        if git stash show &>/dev/null; then
            BRANCH_COLOUR=$stash
            extra_info="${extra_info}+"
        fi
        if [[ $git_status =~ 'working directory clean' ]]; then
            BRANCH_COLOUR=$clean
        fi
        if [[ $git_status =~ 'Your branch is ahead' ]]; then
            BRANCH_COLOUR=$ahead
            extra_info="${extra_info}>"
        fi
        if [[ $git_status =~ 'Your branch is behind' ]]; then
            BRANCH_COLOUR=$behind
            extra_info="${extra_info}<"
        fi
        if [[ $git_status =~ 'Changes to be committed' ]]; then
            BRANCH_COLOUR=$staged
        fi
        if [[ $git_status =~ 'Changed but not updated' ||
            $git_status =~ 'Changes not staged'      ||
            $git_status =~ 'Unmerged paths' ]]; then
                    BRANCH_COLOUR=$dirty
        fi
        if [[ $git_status =~ 'Your branch'.+diverged ]]; then
            BRANCH_COLOUR=$diverged
            extra_info="${extra_info}!"
        fi

        # pad the extra info with a space if it exists
        if [ "${#extra_info}" -gt 1 ]; then
            extra_info=" ${extra_info}"
        fi

        echo -n " ""$RESET_COLOURS""$BRANCH_COLOUR${branch}$DIM$BRANCH_COLOUR${extra_info}$RESET_COLOURS"
    fi
    return 0
}

# building the prompt string

PS1=""
PS1="$PS1""\[$WHITE\]"'['"\[$RESET_COLOURS\]"

# user (show in red if we are root)
if [[ "$(id -u)" -eq 0 ]]; then
    PS1="$PS1""\[$RED\]""\u""\[$RESET_COLOURS\]"
else
    PS1="$PS1""\[$WHITE\]""\u""\[$RESET_COLOURS\]"
fi

# @hostname
PS1="$PS1""\[$WHITE\]"'@'"\[$RESET_COLOURS\]"
PS1="$PS1""\[$WHITE\]""\H""\[$RESET_COLOURS\]"

# [vpn]
PS1="$PS1""\[$DIM\]\[$WHITE\]\$(__vpn_info)\[$RESET_COLOURS\]"

# short path
PS1="$PS1"" "
PS1="$PS1""\[$DIM\]\[$YELLOW\]\$(__shortpath)\[$RESET_COLOURS\]"

# git branch info if any
PS1="$PS1""\$(__gitinfo)"
PS1="$PS1""\[$WHITE\]"']'"\[$RESET_COLOURS\]"

PS1="$PS1""\n"
PS1="$PS1""\[$RESET_COLOURS\]\\$ "

# ----------------------------------------------------------------------

#    _    _  _                        
#   /_\  | |(_)  __ _  ___   ___  ___ 
#  //_\\ | || | / _` |/ __| / _ \/ __|
# /  _  \| || || (_| |\__ \|  __/\__ \
# \_/ \_/|_||_| \__,_||___/ \___||___/
#                                     

# 3_Aliases

# ----------------------------------------------------------------------
# source the fzf bash snippets if we've installed fzf

if [ -f "$HOME/.fzf.bash" ] ; then
    source "$HOME/.fzf.bash"
fi

# ----------------------------------------------------------------------
# Adding things to PATH if they exist
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

append_to_path "$HOME/.local/bin"
append_to_path "$HOME/.bin"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
append_to_path "$PYENV_ROOT/bin"
prepend_to_path "$PYENV_ROOT/shims" # alternative to `eval "$(pyenv init --path)"`

if command -v pyenv &>/dev/null; then
    # start pyenv now that the PATH variables are set
    # but only if we have pyenv installed
    eval "$(pyenv init -)"
fi

# ----------------------------------------------------------------------
# terminal editor

# set the default terminal editor
if command -v nvim &>/dev/null; then
    export VISUAL=nvim
    export EDITOR=nvim
    alias vim='nvim'
else
    export VISUAL=vi
    export EDITOR=vi
fi

# ----------------------------------------------------------------------
# man pager

# I want to use `bat` as the manpager if it's installed so that I get
# syntax highlighting on manpages. Also, since it uses the same keys as
# less, there's no reason not to use it if you have it.

if command -v bat &>/dev/null; then
    export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi                    
                      
# ----------------------------------------------------------------------
# keepass & ssh agent

# this alias is not just to save time, it also makes it possible to pass
# through the SSH_AUTH_SOCK environment variable to keepass, which, in turn,
# allows keepass to hold your SSH keys and feed them to the SSH agent as and
# when it's needed
if command -v keepassxc &>/dev/null; then
    alias kp='keepassxc &>/dev/null &'
fi
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# ----------------------------------------------------------------------
# nix

# if you have Nix installed on your machine, this will source the Nix profile
# into your shell every time you start a new shell

if [ -e "$HOME/.nix-profile/etc/profile.d/nix.sh" ]; then
    source "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# ----------------------------------------------------------------------
# quick config editing

export DOTFILES="$HOME/.config/dotfiles"
export INPUTRC="$DOTFILES/.inputrc"


if [ -f "$INPUTRC" ] ; then
    # ensure that the current INPUTRC is used in the terminal sesh
    # if it's present
    bind -f "$INPUTRC"
fi

alias bp='echo "source ~/.bashrc" && source ~/.bashrc'  # refresh bash

alias vimrc='$EDITOR $HOME/.vimrc'                      # edit vimrc
alias bashrc='$EDITOR $HOME/.bashrc'                    # edit bashrc
alias gitconfig='$EDITOR $HOME/.gitconfig'              # edit gitconfig

alias dotfiles='pushd $DOTFILES'                        # go to dotfiles

alias nv='$DOTFILES/scripts/notes.sh'
alias cheat='$DOTFILES/cheat'
alias cite='python3 $DOTFILES/scripts/cite.py'

# ----------------------------------------------------------------------
# games

# a script that quickly launches games defined in the file.
alias games='$DOTFILES/scripts/games.sh'

# ----------------------------------------------------------------------
# ls

# I want to add symbols for symlinks and use human readable sizes by default
# and I want to use the long format. If `exa`, then use that instead of `ls`
if command -v exa &>/dev/null; then
    alias ls='exa'
    alias ll='exa -l --all --classify --git --header'
else
    alias ll='ls -l --all --classify --human-readable'
fi

# ----------------------------------------------------------------------
# ghq (easily change directories)

function __cd_to_git_repos_folder() {
    if ! command -v ghq &>/dev/null; then
        echo "install ghq first"
    fi
    if ! command -v fzf &>/dev/null; then
        echo "install fzf first"
    fi
    cd "$(ghq list -p | fzf)"
}

alias proj=__cd_to_git_repos_folder

# ----------------------------------------------------------------------
# easy alias for opening stuff

# set the default terminal editor
if command -v xdg-open &>/dev/null; then
    alias open='xdg-open'
fi

# ----------------------------------------------------------------------
# archive.org

# open the archived version of a link in the web browser
# args: $1 = the URL of a website you want to see the archived version of
function wayback() {
    local ARCHIVE_URL
    ARCHIVE_URL="https://web.archive.org/web/$(date +%Y%m%d%H%M%S)/$1"

    echo "opening: $ARCHIVE_URL"
    open_in_browser "$ARCHIVE_URL"
}

# ----------------------------------------------------------------------
# web browsers

# open something from your default web browser
# if xdg-open isn't available then will try to use the following browsers:
#
#   firefox
#   chromium
#   brave-browser
#
# args: $1 = the thing that you want to open from your browser
function open_in_browser() {
    if command -v xdg-open &>/dev/null;
    then
        xdg-open "$1" &>/dev/null

    elif command -v firefox &>/dev/null;
    then
        firefox "$1" &>/dev/null &

    elif command -v chromium &>/dev/null;
    then
        chromium "$1" &>/dev/null &

    elif command -v brave-browser &>/dev/null;
    then
        brave-browser "$1" &>/dev/null &
    else
        echo "cannot open $1"
        echo "please install one of: firefox, chromium or brave-browser"
    fi
}

# ----------------------------------------------------------------------
# nvm (https://github.com/nvm-sh/nvm) for managing node versions

export NVM_DIR="$HOME/.nvm"

# This loads nvm
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# This loads nvm bash_completion
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# ----------------------------------------------------------------------
# work vpn

function vpn-work() {
    # ensure that the vpn config file is there
    if [ ! -f "$DOTFILES/config-work" ];
    then
        echo "aborting! you don't have the 'config-work' file in '$DOTFILES'"
    else
        # ensure that openfortivpn is installed or is in the path
        if command -v openfortivpn &>/dev/null;
        then
            echo "starting vpn connection at $(date --iso-8601=seconds)"
            sudo openfortivpn -c "$DOTFILES/config-work"
            echo "closing vpn connection at $(date --iso-8601=seconds)"
        else
            echo "could not start the VPN connection... you don't have 'openfortivpn' installed or on your path"
        fi
    fi
}

# ----------------------------------------------------------------------
# git

alias fp='git fetch --all --prune && git pull'

function __delete_merged_branches() {
    git fetch -p
    for branch in $(git branch -vv | grep ': gone]' | awk '{print $1}'); do
        git branch -D "$branch";
    done
}
alias dmb=__delete_merged_branches

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
            *.7z)        ( set -x; 7z x "$1"       ) ;;
            *.deb)       ( set -x; ar x "$1"       ) ;;
            *.tar.xz)    ( set -x; tar xf "$1"     ) ;;
            *.tar.zst)   ( set -x; unzstd "$1"     ) ;;
            *)           echo "'$1' cannot be extracted via ex()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# ----------------------------------------------------------------------
# moving to the firefox profile folder quickly

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

# ----------------------------------------------------------------------
# hashing stuff

# desc: generate a subresource integrity hash for a file
# args: $1 = the path to the file you want to make the hash for
sri() {
    echo "generating SRI hash for $1"

    # make sure stuff is installed so you can generate the hash
    command -v shasum > /dev/null 2>&1 || echo "please install 'shasum' to continue"
    command -v awk > /dev/null 2>&1 || echo "please install 'awk' to continue"
    command -v xxd > /dev/null 2>&1 || echo "please install 'xxd' to continue"
    command -v base64 > /dev/null 2>&1 || echo "please install 'base64' to continue"

    # https://developer.mozilla.org/en-US/docs/Web/Security/Subresource_Integrity
    echo "sha384-$(shasum -b -a 384 "$1" | awk '{ print $1 }' | xxd -r -p | base64)"
}

# desc: hashes a given string
# args: $1 = the string that you want to hash
function hash_string() {
    echo "$1" | md5sum | cut -f1 -d" "
}
