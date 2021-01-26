#!/bin/bash

# A script that'll zip up a folder and then put it in a designated temporary
# folder for you to then manually move somewhere else

# ---------------------------------------------------------------------------
# HELPER FUNCTIONS

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


# ---------------------------------------------------------------------------
# STUFF THAT NEEDS TO BE INSTALLED TO RUN THIS SCRIPT

require basename "naming the tarball backup archives"
require date "timestamping the tarball backup file"
require tar "compressing the backup"
#require gpg "encrypting the backup"

# ---------------------------------------------------------------------------
# MODIFY THESE BEFORE RUNNING THE SCRIPT!

# a folder which will be created to temporarily put archive you wanna back up
# you can make it a remote dir if you want to ssh to a machine and have the
# backup over there
REMOTE_BACKUP_DIR="user@server:/mnt/storage/manual-backups"

# a directory to temporarily place the files before they get copied over to 
# the remote folder
TEMP_DIR="$HOME/backups_temp"

mkdir -p "$TEMP_DIR"

# yes, they have to be folders
FOLDERS_TO_BE_BACKED_UP=(
    "$HOME/.ssh"
    "/etc"
    "/var/spool/cron"
)

log "FOLDERS_TO_BE_BACKED_UP=${FOLDERS_TO_BE_BACKED_UP[*]}"
log "REMOTE_BACKUP_DIR=$REMOTE_BACKUP_DIR"
TODAY=$(date --iso)
log "TODAY=$TODAY"

cleanup() {
    log "Cleaning up temp folder"
    rm -rfv "$TEMP_DIR"
}

trap cleanup EXIT

for FOLDER in "${FOLDERS_TO_BE_BACKED_UP[@]}"; do
    
    cd "$FOLDER" || oops "failed to 'cd' to '$FOLDER'"
    BACKUP_NAME="$(basename "$PWD")"

    log "$BACKUP_NAME:"
    log "  Backing up '$FOLDER' to '$BACKUP_DIR'"

    TARBALL_PATH="$TEMP_DIR/$BACKUP_NAME""_""$TODAY.tar.gz"
    log "    Requesting sudo privileges to back up '$PWD' in case some files are restricted"
    sudo tar \
        --create \
        --preserve-permissions \
        --gzip \
        --file="$TARBALL_PATH" . \
        --verbose \
        || oops "something went wrong creating '$TARBALL_PATH' - please investigate"

    log "  Successfully created '$TARBALL_PATH' as a backup of '$FOLDER'"
    log "  Copying tarball to '$REMOTE_BACKUP_DIR'..."
    rsync -avz "$TARBALL_PATH" "$REMOTE_BACKUP_DIR" \
        || oops "Something went wrong copying '$TARBALL_PATH' to '$REMOTE_BACKUP_DIR' - please investigate"

    log "  Successfully copied the tarball to the remote server, removing from machine..."
    rm -v "$TARBALL_PATH"

done

log "Done!"

exit 0
