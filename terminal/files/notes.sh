#!/bin/bash

# ---------------------------------------------------------------------- 
# Variables

NOTES_FOLDER="$HOME/.nb/notes"

RIPGREP_OPTS=(
    "--follow"
    "--smart-case"
    "--line-number"
    "--color" "never"
    "--no-messages"
    "--no-heading"
    "--with-filename"
)

FZF_OPTS=(
    "--height" "10%"
    "--border"
    "--layout=reverse"
    "--cycle"
)

# ---------------------------------------------------------------------- 
# Util function/s

# echo an error message and exit the script
oops() {
    echo "$0:" "$@" >&2
    exit 1
}

# args: $1 = a binary you want to require e.g. tar, gpg, mail
#       $2 = a message briefly describing what you need the binary for
require() {
    command -v "$1" > /dev/null 2>&1 \
        || oops "you do not have '$1' installed; needed for: $2"
}

log() {
    echo "[$(date)] - $1"
}

do_validation() {
    require nb "needed for managing notes"
    require fzf "filtering search results"
    require xsel "copying result to clipboard"
    require tee "printing stuff to terminal after doing it"
    require awk "manipulating search results"
    require find "finding files"
    require sort "sorting search results"
    require sed "manipulating text from search results"
    require head "getting the first line from a file"
    require date "getting the date"

    if [ ! -d "$NOTES_FOLDER" ] ; then
        echo "cannot search permanotes, you haven't got the 'notes' notebook"
        return 1
    fi
}

# ---------------------------------------------------------------------- 
# Actual logic

function to_markdown_link() {
    local PATH_TO_FILE
    local TITLE

    if [[ -z "$1" ]]; then
      oops "\$1 is empty"
    fi

    PATH_TO_FILE="$NOTES_FOLDER/$1"
    if [[ ! -f "$PATH_TO_FILE" ]]; then
        oops "$PATH_TO_FILE is not a file"
    fi

    TITLE="$(head -n1 "$PATH_TO_FILE" | sed "s/# //g")"

    echo "[$TITLE]($1)"
}

search_notes_full_text() {
    export -f to_markdown_link
    export NOTES_FOLDER

    rg . "$NOTES_FOLDER" "${RIPGREP_OPTS[@]}" \
        | awk '
            BEGIN {
                FS=":"
                OFS="\t"
            }
            function basename(file) {
                sub(".*/", "", file)
                return file
            }
            {
                print basename($1),$3
            }' \
        | fzf --cycle \
        | awk '
            BEGIN {
                FS="\t"
            }
            {
                print $1
            }' \
        | xargs -n 1 -P 10 -I {} bash -c 'to_markdown_link "$@"' _ {} \
        | tee /dev/tty \
        | xsel --clipboard
}

search_notes_by_title() {
    find "$NOTES_FOLDER" -type f -name "*\.md" -printf %f -exec head -n1 "{}" \; \
        | sort -r \
        | sed 's/# /\t/g' \
        | fzf \
        | awk '
            BEGIN {
                FS = "\t"
            }
            {
                printf "[%s](%s)", $2, $1
            }' \
        | tee /dev/tty \
        | xsel --clipboard

    # `tee /dev/tty` outputs the thing in the pipe to stdout before passing it through
    # https://stackoverflow.com/a/5677265
    # https://web.archive.org/web/20201227082859/https://stackoverflow.com/questions/5677201/how-to-pipe-stdout-while-keeping-it-on-screen-and-not-to-a-output-file
}

create_permanote() {
    (
        set -x;
        nb notes:add --filename "$(date +"%Y-%m-%dT%H%M%SZ" --universal).md"
    )
}

create_fleeting_note() {
    local FILENAME
    local PATH_TO_FILE
    FILENAME="$(date --iso --universal).md"
    PATH_TO_FILE="$NOTES_FOLDER/$FILENAME"

    if [[ ! -e "$PATH_TO_FILE" ]]; then
        nb notes:add \
            --filename "$FILENAME" \
            --title "$(date +"%B %e, %Y")"
    else
        $EDITOR "$PATH_TO_FILE"
    fi
}

save_url() {
    read -e -p "URL> " URL
    (
        set -x;
        nb use notes
        nb bookmark "$URL" \
            --filename "$(date +"%Y-%m-%dT%H%M%SZ" --universal).md" \
            --comment "::Bookmark::" \
            --skip-content \
            --edit
    )
}

choose_action_and_do_it() {
    local OPTIONS=(
        'Search all'
        'Search titles'
        'Create permanote'
        'Create fleeting note'
        'Save URL'
        'Re-index notes'
    )

    local ACTION
    ACTION="$(printf '%s\n' "${OPTIONS[@]}" | fzf "${FZF_OPTS[@]}")"

    case "$ACTION" in
        'Search all')
            search_notes_full_text
            ;;

        'Search titles')
            search_notes_by_title
            ;;

        'Create permanote')
            create_permanote
            ;;

        'Create fleeting note')
            create_fleeting_note
            ;;

        'Save URL')
            save_url
            ;;

        'Re-index notes')
            (set -x; nb index rebuild)
            ;;

        *)
            exit 0
            ;;
    esac
}

# ---------------------------------------------------------------------- 
# Main script execution

do_validation
choose_action_and_do_it

