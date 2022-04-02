# ----------------------------------------------------------------------

#    ___                                 _
#   / _ \ _ __   ___   _ __ ___   _ __  | |_
#  / /_)/| '__| / _ \ | '_ ` _ \ | '_ \ | __|
# / ___/ | |   | (_) || | | | | || |_) || |_
# \/     |_|    \___/ |_| |_| |_|| .__/  \__|
#                                |_|

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

# short path
PS1="$PS1"" "
PS1="$PS1""\[$DIM\]\[$YELLOW\]\$(__shortpath)\[$RESET_COLOURS\]"

# git branch info if any
PS1="$PS1""\$(__gitinfo)"
PS1="$PS1""\[$WHITE\]"']'"\[$RESET_COLOURS\]"

PS1="$PS1""\n"
PS1="$PS1""\[$RESET_COLOURS\]\\$ "

# put the toolbox symbol at the front of the prompt if we are in a container
# (snippet taken from /etc/profile.d/toolbox.sh)
# see also: https://old.reddit.com/r/Fedora/comments/rlnh9b/toolbox_terminal_prompt/
if [ -f /run/.containerenv ] && [ -f /run/.toolboxenv ]; then
    [ "${BASH_VERSION:-}" != "" ] && PS1=$(printf "\[\033[35m\]⬢\[\033[0m\]%s" "$PS1")
fi
