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

# ---------------------------------------------------------------------------
# TABLE OF CONTENTS
# ---------------------------------------------------------------------------

# In Vim, press * on the below words to go to the section that they
# refer to:
#
#   1_Defaults
#   2_Aliases
#   3_Prompt
#   4_Notes
#

# ---------------------------------------------------------------------------

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

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        color_prompt=
    fi
fi

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# Enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"

    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

VISUAL=nvim; export VISUAL EDITOR=nvim; export EDITOR

# ---------------------------------------------------------------------------

#    _    _  _                        
#   /_\  | |(_)  __ _  ___   ___  ___ 
#  //_\\ | || | / _` |/ __| / _ \/ __|
# /  _  \| || || (_| |\__ \|  __/\__ \
# \_/ \_/|_||_| \__,_||___/ \___||___/
#                                     

# 2_Aliases

[ -f ~/.fzf.bash ] && source ~/.fzf.bash

# set PATH so it includes user's private bin if it exists
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# Add Rust to $PATH
export PATH="$HOME/.cargo/bin:$PATH"

alias vim='nvim'

# Quick config editing
alias vimrc='vim ~/.vimrc'
alias bashrc='vim ~/.bashrc'
alias gitconfig='vim ~/.gitconfig'
alias dotfiles='pushd ~/dotfiles'
alias c='clear'
alias bp='echo "source ~/.bashrc" && source ~/.bashrc'

alias ll='ls -alFh'

alias vpn-work='sudo openfortivpn -c /etc/openfortivpn/config-work'

# loops through every folder in the current dir and zips them up
alias zipall='for i in */; do zip -r "${i%/}.zip" "$i"; done'

# ---------------------------------------------------------------------------

#    ___                                 _   
#   / _ \ _ __   ___   _ __ ___   _ __  | |_ 
#  / /_)/| '__| / _ \ | '_ ` _ \ | '_ \ | __|
# / ___/ | |   | (_) || | | | | || |_) || |_ 
# \/     |_|    \___/ |_| |_| |_|| .__/  \__|
#                                |_|         

# 3_Prompt

BLACK=$(tput setaf 0)
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
BLUE=$(tput setaf 4)
MAGENTA=$(tput setaf 5)
CYAN=$(tput setaf 6)
WHITE=$(tput setaf 7)
DIM=$(tput dim)
RESET_COLOURS=$(tput sgr0)
 
# a function to get the short path of some directory, so it doesn't take up a lot of space on the screen
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
 
# building the prompt string, the [0] is the exit code of the previous command
PS1="\n"

# show the username in red if we are root
if [[ "`id -u`" -eq 0 ]]; then
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
PS1="$PS1""\[$RESET_COLOURS\]> "

# ---------------------------------------------------------------------------

#      __         _              
#   /\ \ \  ___  | |_   ___  ___ 
#  /  \/ / / _ \ | __| / _ \/ __|
# / /\  / | (_) || |_ |  __/\__ \
# \_\ \/   \___/  \__| \___||___/
#                                

# 4_Notes
# I use a single 'did' function to put all of my notes into a single
# file. Each entry has the date and time above it. All of the entries
# go one after the other, with the newest entry at the bottom.
# This makes it easier to search and back up (you can just attach this
# notes file in an email to yourself and put the emails into a folder
# somewhere)

DID_LOCATION=~/Documents/did.txt

alias didv='less $DID_LOCATION'
alias didvt='grep "$(date -I)" -A 999 ~/Documents/did.txt | less'
alias didvy='grep "$(date -d "'"yesterday"'" -I)" -A 999 ~/Documents/did.txt | less'

# desc: hashes a given string
# args: $1 = the string that you want to hash
function hash_string() {
    echo "$1" | md5sum | cut -f1 -d" "
}

# desc: append to the 'did' file
# args: the tags that you want to give to this 'did' entry
function did() {
    local DATE_FORMATTED
    DATE_FORMATTED=$(date +"%Y-%m-%d %T (%A)")

    test -f "$DID_LOCATION" || touch "$DID_LOCATION"

    # three spaces after the previous thing
    echo >> "$DID_LOCATION"
    echo >> "$DID_LOCATION"
    echo >> "$DID_LOCATION"

    # put the formatted date under the spacing
    echo "$DATE_FORMATTED" >> "$DID_LOCATION"

    # hash the datetime and put it under the date
    # this provides a unique identifier of the note that you can 'link'
    # to from other notes and jump to using search (ctrl+f or whatever).
    echo "hash: $(hash_string "$DATE_FORMATTED")" >> $DID_LOCATION

    # put all of the tags that were passed in as parameters on one line
    if [[ $# -ne 0 ]]; then
        printf "tags: " >> "$DID_LOCATION"
        for tag in "$@"
        do
            printf "@%s " "$tag" >> "$DID_LOCATION"
        done
    fi

    # a few things happening here:
    # - open vim
    #   - go to end of file and open a blank newline
    #   - (this would be just under the text we added above)
    #   - open another blank newline and add two spaces (for indent)
    # - set the textwidth to 72 characters
    # - make sure that text wraps automatically
    # 
    # you can then immediately start typing since we start vim in
    # insert mode
    vim "+normal Go" "+normal Go   " +startinsert    \
        -c "set tw=72"                               \
        -c "set fo?"                                 \
        -c "set fo+=t"                               \
        -c "set fo-=l"                               \
        "$DID_LOCATION"
}
