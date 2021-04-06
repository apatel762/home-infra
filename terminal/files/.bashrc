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

# ignore case when using TAB completion
bind "set completion-ignore-case on"

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
    extra_info=" "
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
        echo -n " ""$RESET_COLOURS""$BRANCH_COLOUR${branch}$DIM$BRANCH_COLOUR${extra_info}$RESET_COLOURS"
    fi
    return 0
}

# building the prompt string
PS1="\n"

# show the username in red if we are root
if [[ "$(id -u)" -eq 0 ]]; then
    PS1="$PS1""\[$RED\]""\u""\[$RESET_COLOURS\]"
else
    PS1="$PS1""\[$WHITE\]""\u""\[$RESET_COLOURS\]"
fi

PS1="$PS1""\[$WHITE\]"'@'"\[$RESET_COLOURS\]"
PS1="$PS1""\[$WHITE\]""\H""\[$RESET_COLOURS\]"
PS1="$PS1"":"
PS1="$PS1""\[$DIM\]\[$YELLOW\]\`__shortpath\`\[$RESET_COLOURS\]"
PS1="$PS1""\`__gitinfo\`"
PS1="$PS1""\n"

# make the last bit of prompt a '#' for root and '%' for
# everything else
if [[ "$(id -u)" -eq 0 ]]; then
    PS1="$PS1""\[$RESET_COLOURS\]# "
else
    PS1="$PS1""\[$RESET_COLOURS\]% "
fi

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

if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

if [ -d "$HOME/.bin" ] ; then
    PATH="$HOME/.bin:$PATH"
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
# quick config editing

export DOTFILES="$HOME/.config/dotfiles"
export INPUTRC="$DOTFILES/.inputrc"

alias vimrc='$EDITOR $HOME/.vimrc'                      # edit vimrc
alias bashrc='$EDITOR $HOME/.bashrc'                    # edit bashrc
alias gitconfig='$EDITOR $HOME/.gitconfig'              # edit gitconfig
alias dotfiles='pushd $DOTFILES'                        # go to dotfiles
alias bp='echo "source ~/.bashrc" && source ~/.bashrc'  # refresh bash
alias nv='$DOTFILES/scripts/notes.sh'

# ----------------------------------------------------------------------
# ls

# I want to add symbols for symlinks and use human readable sizes by default
# and I want to use the long format
alias ll='ls -l --all --classify --human-readable'

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
# work vpn

function vpn-work() {
    # ensure that the vpn config file is there
    if [ ! -f "/etc/openfortivpn/config-work" ];
    then
        echo "aborting! you don't have the 'config-work' file in '/etc/openfortivpn'"
    else
        # ensure that openfortivpn is installed or is in the path
        if command -v openfortivpn &>/dev/null;
        then
            echo "starting vpn connection at $(date --iso-8601=seconds)"
            sudo openfortivpn -c /etc/openfortivpn/config-work
            echo "closing vpn connection at $(date --iso-8601=seconds)"
        else
            echo "could not start the VPN connection... you don't have 'openfortivpn' installed or on your path"
        fi
    fi
}

# ----------------------------------------------------------------------
# git

alias fp='git fetch --all --prune && git pull'
alias dmb='git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d'

# ----------------------------------------------------------------------
# zip utils

# loops through every folder in the current dir and zips them up
alias zipall='for i in */; do zip -r "${i%/}.zip" "$i"; done'

# desc: extract an archive using one of many different archive commands
# args: $1 = the path to the archive to extract
ex ()
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
# managing firefox profile

alias ffp=firefox_profile
function firefox_profile() {
    local FIREFOX_PROFILE_FOLDER
    FIREFOX_PROFILE_FOLDER="$HOME/.mozilla/firefox/ty2439dj.default-1558852188159"

    if [ -d "$FIREFOX_PROFILE_FOLDER" ] ; then
        cd "$FIREFOX_PROFILE_FOLDER" \
            || return 1
                else
                    echo "sorry, the firefox profile folder you defined doesn't exist"
                    echo "folder: '$FIREFOX_PROFILE_FOLDER'"
    fi
}

function update_material_fox() {
    local GITHUB_FOLDER
    GITHUB_FOLDER="$HOME/Documents/Github"

    echo "making $GITHUB_FOLDER"
    mkdir -p "$GITHUB_FOLDER"

    if [ ! -d "$GITHUB_FOLDER/materialfox" ] ; then
        echo "cloning 'materialfox'"
        git clone https://github.com/muckSponge/MaterialFox.git "$GITHUB_FOLDER/materialfox"
    else
        echo "you already have 'materialfox' - skipping git clone"
    fi

    cd "$GITHUB_FOLDER/materialfox" && git fetch --all --prune && git pull --autostash --rebase

    # function to go to the firefox profile folder
    firefox_profile

    echo "copying the chrome folder to your firefox profile"
    cp -rvu "$GITHUB_FOLDER/materialfox/chrome" -t .
    echo "done copying files!"
    echo ""
    echo "check the materialfox README.md"
    echo "there is some stuff that needs to be added to your user-overrides.js in $PWD"
}

# ----------------------------------------------------------------------
# cheatsheets

# TODO: 
#  make these cheatsheets use a script and alias the script
#  and move the alias nearer to the top of this file
#  and update the Ansible config
#  https://github.com/apatel762/dotfiles/issues/2

function show_ssh_agent_instructions() {
    if [ -f "$DOTFILES/cheatsheets/sshagent.txt" ] ; then
        printf "\n"
        cat "$DOTFILES/cheatsheets/sshagent.txt"
        printf "Currently:\n"
        ssh-add -l
    else
        :
    fi
}

# this alias is literally just so i can remind myself of how to generate ssh
# keys because i dont do it often...
alias ssh_cmds='more $DOTFILES/ssh.txt'
alias ssh_agent=show_ssh_agent_instructions

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
