#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

usage() {
    echo "Usage: $0 playbook env"
    echo "  playbook:  the name of the playbook file (something.yml)"
    echo "       env:  the environment"
    echo "               ws = workstation"
    echo "               hs = server"
}

ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

PASSWORD_FILE_FOR_SUDO="$ROOTDIR/../secrets/sudo_password"
PASSWORD_FILE_FOR_VAULT="$ROOTDIR/../secrets/vault_password"

# desc: Handler for unexpected errors
# args: $1 (optional): Exit code (defaults to 1)
# outs: None
function script_trap_err() {
    local exit_code=1

    # Disable the error trap handler to prevent potential recursion
    trap - ERR

    # Consider any further errors non-fatal to ensure we run to completion
    set +o errexit
    set +o pipefail

    # Validate any provided exit code
    if [[ ${1-} =~ ^[0-9]+$ ]]; then
        exit_code="$1"
    fi

    # Restore original file output descriptors
    if [[ -n ${script_output-} ]]; then
        exec 1>&3 2>&4
    fi

    # Print basic debugging information
    printf '%b\n' "$ta_none"
    printf '***** Abnormal termination of script *****\n'
    printf 'Script Path:            %s\n' "$script_path"
    printf 'Script Parameters:      %s\n' "$script_params"
    printf 'Script Exit Code:       %s\n' "$exit_code"

    # Print the script log if we have it. It's possible we may not if we
    # failed before we even called cron_init(). This can happen if bad
    # parameters were passed to the script so we bailed out very early.
    if [[ -n ${script_output-} ]]; then
        # shellcheck disable=SC2312
        printf 'Script Output:\n\n%s' "$(cat "$script_output")"
    else
        printf 'Script Output:          None (failed before log init)\n'
    fi

    # Exit with failure status
    exit "$exit_code"
}

trap script_trap_err ERR

# desc: Exit script with the given message
# args: $1 (required): Message to print on exit
#       $2 (optional): Exit code (defaults to 0)
# outs: None
# note: The convention used in this script for exit codes is:
#       0: Normal exit
#       1: Abnormal exit due to external error
#       2: Abnormal exit due to script error
function script_exit() {
    if [[ $# -eq 1 ]]; then
        printf '%s\n' "$1"
        exit 0
    fi

    if [[ ${2-} =~ ^[0-9]+$ ]]; then
        printf '%b\n' "$1"
        # If we've been provided a non-zero exit code run the error trap
        if [[ $2 -ne 0 ]]; then
            script_trap_err "$2"
        else
            exit 0
        fi
    fi

    script_exit 'Missing required argument to script_exit()!' 2
}

# desc: Pretty print the provided string
# args: $1 (required): Message to print (defaults to a green foreground)
#       $2 (optional): Colour to print the message with. This can be an ANSI
#                      escape code or one of the prepopulated colour variables.
#       $3 (optional): Set to any value to not append a new line to the message
# outs: None
function pretty_print() {
    if [[ $# -lt 1 ]]; then
        script_exit 'Missing required argument to pretty_print()!' 2
    fi

    if [[ -z ${no_colour-} ]]; then
        if [[ -n ${2-} ]]; then
            printf '%b' "$2"
        else
            printf '%b' "$fg_green"
        fi
    fi

    # Print message & reset text attributes
    if [[ -n ${3-} ]]; then
        printf '%s%b' "$1" "$ta_none"
    else
        printf '%s%b\n' "$1" "$ta_none"
    fi
}

# desc: Ensure that we have the requested password file
# args: $1 (required): The program that we want the password file for
#       $2 (required): The expected location of the password file
function ensure_password_file() {
    if [[ ! -f "$2" ]]; then
        pretty_print "The expected $1 password file doesn't exist. Please do the following:

    $EDITOR $2
    chmod u=r,go-rwx $2

Please create $2 with strict permissions and re-run this script." "${fg_yellow-}"

        script_exit "Exiting..." 1
    fi
}

function await_ostree_idle() {
    if [ -f "$ROOTDIR/_await-ostree-idle.sh" ]; then
        ensure_password_file "ssh" "$PASSWORD_FILE_FOR_SUDO"
        sshpass -f "$PASSWORD_FILE_FOR_SUDO" ssh ::1 bash < "$ROOTDIR/_await-ostree-idle.sh"
    else
        script_exit "Could not find '$ROOTDIR/_await-ostree-idle.sh'. Are you running this script via the Makefile?" 1
    fi
}

# args: $1 = the playbook file
#       $2 = the environment (workstation or server)
function playbook() {
    if [ -z "$1" ]; then
        usage;
        script_exit "Argument 'playbook' is required." 1
    fi
    if [ -z "$2" ]; then
        usage;
        script_exit "Argument 'env' is required." 1
    fi
    local PLAYBOOK
    PLAYBOOK="$1"
    local ENV
    ENV="$2"

    ensure_password_file "ssh" "$PASSWORD_FILE_FOR_SUDO"_"$ENV"
    ensure_password_file "ansible-vault" "$PASSWORD_FILE_FOR_VAULT"

    cd "$ROOTDIR/../.."

    # ensure that the python venv exists before trying to run the playbook
    if [ ! -d "venv" ]; then
        script_exit "Could not find the Python venv, please run 'make install' and try again." 1
    fi

    source venv/bin/activate

    # TODO: construct the args one at a time just above this line and use them all at once
    #    see https://linuxhandbook.com/bash-arrays/
    time ansible-playbook \
        --diff \
        --become-password-file "$PASSWORD_FILE_FOR_SUDO"_"$ENV" \
        --connection-password-file "$PASSWORD_FILE_FOR_SUDO"_"$ENV" \
        --vault-password-file "$PASSWORD_FILE_FOR_VAULT" \
        --inventory hosts.ini \
        ansible/"$PLAYBOOK"
}

# desc: show a yes or no prompt with the given message (abort if the user doesn't type "y")
# args: $1 = a message to display
function yes_no() {
    if [ -z "$1" ]; then
        script_exit "error: must provide message for yes_no prompt (this is a bug)" 1
    fi
    local MESSAGE
    MESSAGE="$1"

    echo "$MESSAGE"
    read -p "Do you want to proceed? y/[n]: " yn

    case $yn in
        [yY][eE][sS]|[yY])
            :
            ;;
        *)
            script_exit "Aborting..." 0
            ;;
    esac
}