#!/bin/bash

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

function to_markdown_link() {
    local PATH_TO_FILE
    local TITLE

    if [[ -z "$1" ]]; then
      echo "\$1 is empty"
      exit 1
    fi

    PATH_TO_FILE="$NOTES_FOLDER/$1" 
    if [[ ! -f "$PATH_TO_FILE" ]]; then
        echo "$PATH_TO_FILE is not a file"
    fi

    TITLE="$(head -n1 "$PATH_TO_FILE" | sed "s/# //g")"

    echo "[$TITLE]($1)"
}

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
