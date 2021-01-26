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

# ---------------------------------------------------------------------------
# TABLE OF CONTENTS
# ---------------------------------------------------------------------------

# In Vim, press * on the below words to go to the section that they
# refer to:
#
#   1_Defaults
#   2_Prompt
#   3_Aliases
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

# shellcheck disable=SC2154
if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
        # We have color support; assume it's compliant with Ecma-48
        # (ISO/IEC-6429). (Lack of such support is extremely rare, and such
        # a case would tend to support setf rather than setaf.)
        color_prompt=yes
    else
        # shellcheck disable=SC2034
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

# ---------------------------------------------------------------------------

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
PS1="$PS1""\[$RESET_COLOURS\]> "

# ---------------------------------------------------------------------------

#    _    _  _                        
#   /_\  | |(_)  __ _  ___   ___  ___ 
#  //_\\ | || | / _` |/ __| / _ \/ __|
# /  _  \| || || (_| |\__ \|  __/\__ \
# \_/ \_/|_||_| \__,_||___/ \___||___/
#                                     

# 3_Aliases

# ---------------------------------------------------------
# source the fzf bash snippets if we've installed fzf
if [ -f "$HOME/.fzf.bash" ] ; then
    source "$HOME/.fzf.bash"
fi

# ---------------------------------------------------------
# Adding things to PATH if they exist

# local bin
if [ -d "$HOME/.local/bin" ] ; then
    PATH="$HOME/.local/bin:$PATH"
fi

# doom emacs
if [ -d "$HOME/.emacs.d/bin" ] ; then
    PATH="$HOME/.emacs.d/bin:$PATH"
fi

# rust
if [ -d "$HOME/.cargo/bin" ] ; then
    PATH="$HOME/.cargo/bin:$PATH"
fi

# node
# binaries from https://nodejs.org/en/download/
if [ -d "$HOME/Documents/Github/node-v14.15.1-linux-x64/bin" ] ; then
    PATH="$HOME/Documents/Github/node-v14.15.1-linux-x64/bin:$PATH"
fi

# ---------------------------------------------------------

# set the default terminal editor
if command -v nvim &>/dev/null; then
    export VISUAL=nvim
    export EDITOR=nvim
    alias vim='nvim'
else
    export VISUAL=vi
    export EDITOR=vi
fi

# set emacs to always open in terminal by default if installed
if command -v emacs &>/dev/null; then
    alias emacs='emacs -nw'
fi

# this alias is not just to save time, it also makes it possible to pass
# through the SSH_AUTH_SOCK environment variable to keepass, which, in turn,
# allows keepass to hold your SSH keys and feed them to the SSH agent as and
# when it's needed
if command -v keepassxc &>/dev/null; then
    alias kp='keepassxc &>/dev/null &'
fi
export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

# Quick config editing
alias vimrc='vim ~/.vimrc'
alias bashrc='vim ~/.bashrc'
alias gitconfig='vim ~/.gitconfig'
alias dotfiles='pushd ~/dotfiles'
alias c='clear'
alias bp='echo "source ~/.bashrc" && source ~/.bashrc'

# note taking
NOTES_FOLDER="$HOME/.nb/notes" 

function pn() {
    if ! command -v nb &>/dev/null; then
        echo "cannot make permanote, you don't have nb installed"
        return 1
    fi
    if [ ! -d "$NOTES_FOLDER" ] ; then
        echo "cannot make permanote, you haven't got the 'notes' notebook"
        return 1
    fi

    nb notes:add --filename "$(date +"%Y-%m-%dT%H%M%SZ" --universal).md"
}

function ns() {
    if ! command -v nb &>/dev/null; then
        echo "please install 'nb' - can't search notes without it!"
        return 1
    fi
    if ! command -v fzf &>/dev/null; then
        echo "please install 'fzf' - needed for filtering search results"
        return 1
    fi
    if ! command -v xsel &>/dev/null; then
        echo "please install 'xsel' - needed for copying result to clipboard"
        return 1
    fi
    if [ ! -d "$NOTES_FOLDER" ] ; then
        echo "cannot search permanotes, you haven't got the 'notes' notebook"
        return 1
    fi

    find "$NOTES_FOLDER" -type f -name "*\.md" -printf %f -exec head -n1 "{}" \; \
        | sort -r \
        | sed 's/# /\t/g' \
        | fzf \
        | awk 'BEGIN { FS = "\t" } { printf "[%s](%s)", $2, $1 }' \
        | tee /dev/tty \
        | xsel --clipboard

    echo ""
    echo "the above link has been copied to your clipboard"

    # `tee /dev/tty` outputs the thing in the pipe to stdout before passing it through
    # https://stackoverflow.com/a/5677265
    # https://web.archive.org/web/20201227082859/https://stackoverflow.com/questions/5677201/how-to-pipe-stdout-while-keeping-it-on-screen-and-not-to-a-output-file
}

# I want to add symbols for symlinks and use human readable sizes by default
# and I want to use the long format
alias ll='ls -l --all --classify --human-readable'

# open the archived version of a link in the web browser
# args: $1 = the URL of a website you want to see the archived version of
function wayback() {
    local ARCHIVE_URL
    ARCHIVE_URL="https://web.archive.org/web/$(date +%Y%m%d%H%M%S)/$1"

    echo "opening: $ARCHIVE_URL"
    open_in_browser "$ARCHIVE_URL"
}

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

alias vpn-work='sudo openfortivpn -c /etc/openfortivpn/config-work'

# loops through every folder in the current dir and zips them up
alias zipall='for i in */; do zip -r "${i%/}.zip" "$i"; done'

# git
alias fp='git fetch --all --prune && git pull'
alias dmb='git branch --merged | egrep -v "(^\*|master|main|dev)" | xargs git branch -d'

# desc: hashes a given string
# args: $1 = the string that you want to hash
function hash_string() {
    echo "$1" | md5sum | cut -f1 -d" "
}

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

function bookmarks_sync() {
    if ! command -v rsync ; then
      echo "need rsync"
      return 1
    fi

    local BOOKMARKS_FOLDER
    BOOKMARKS_FOLDER="$HOME/Downloads/bookmarks"

    local REMOTE_FOLDER
    REMOTE_FOLDER="amigo@broadwater.local:/var/broadwater/bookmarks/raw/"

    # go to where the bookmarks are
    echo "moving to the bookmarks folder"
    cd "$BOOKMARKS_FOLDER" || return 1

    # put the newly downloaded stuff into the folder and copy it to broadwater
    mv -vi ../*.html . \
        && python3 create_index.py \
        && rsync -avz "$BOOKMARKS_FOLDER"/*.html "$REMOTE_FOLDER"

    # go back where we were now that we are done
    echo "moving back to the folder we were in"
    cd - || return 1
}

# this alias is literally just so i can remind myself of how to generate ssh
# keys because i dont do it often...
function ssh_cmds() {
    more << EOF
Create a key without having to go through the interactive menu[1][2]

  ssh-keygen -f ~/.ssh/my.key -t rsa -b 4096 -C my_comment


Copying the key to a server that you have access to. This is useful for if
you are rotating your SSH key (i.e. putting the new one onto the server and
then deleting the old one)

  ssh-copy-id -i ~/.ssh/my.key user@remote


Alternatively, you could do it the long way/manually.
- copy ~/.ssh/my.key.pub to clipboard (or email it or write it down...)
- then append it to remote:/home/user/.ssh/authorized_keys

If you get an error like this:

  sign_and_send_pubkey: signing failed: agent refused operation

It's probably because you have enabled the 'Require user confirmation when
this key is used'[3][4] option in KeePassXC or your keys need stricter
permission. If it's the permissions thing then:

  chmod 600 my.key
  chmod 644 my.key.pub


Here is some info re: using the SSH Agent[5]

  # start SSH-Agent
  ubuntu@node01:~$ eval \$(ssh-agent)
  Agent pid 1592

  # add Identity
  ubuntu@node01:~$ ssh-add
  Enter passphrase for /home/ubuntu/.ssh/id_rsa:
  Identity added: /home/ubuntu/.ssh/id_rsa (ubuntu@dlp.srv.world)

  # confirm
  ubuntu@node01:~$ ssh-add -l
  3072 SHA256:8c0JKIhM5yPk6Kd2YloCsiKOKKjqPu5Qcot94/buwEg ubuntu@dlp.srv.world (RSA)

  # try to conenct with SSH without passphrase
  ubuntu@node01:~$ ssh dlp.srv.world hostname
  dlp.srv.world

  # exit from SSH-Agent
  ubuntu@node01:~$ eval \$(ssh-agent -k)
  Agent pid 1592 killed

[1]: https://www.ssh.com/ssh/keygen/#specifying-the-file-name
[2]: https://web.archive.org/web/20201222143417/https://www.ssh.com/ssh/keygen/
[3]: https://rtfm.co.ua/en/keepass-an-mfa-totp-codes-a-browsers-passwords-ssh-keys-passwords-storage-configuration-and-secret-service-integration/
[4]: https://web.archive.org/web/20210116130536/https://rtfm.co.ua/en/keepass-an-mfa-totp-codes-a-browsers-passwords-ssh-keys-passwords-storage-configuration-and-secret-service-integration/
[5]: https://www.server-world.info/en/note?os=Ubuntu_20.04&p=ssh&f=7 20210124100000

Extra:
https://blog.valouille.fr/post/2018-03-27-how-to-use-keepass-xc-with-ssh-agent/
EOF
}

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
