#!/usr/bin/env bash

# Exit immediately if a command exits with a non-zero status.
set -e

ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

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
            printf '%b' "$(tput setaf 2 2>/dev/null || true)"
        fi
    fi

    # Print message & reset text attributes
    local -r ta_none="$(tput sgr0 2>/dev/null || true)"
    if [[ -n ${3-} ]]; then
        printf '%s%b' "$1" "$ta_none"
    else
        printf '%s%b\n' "$1" "$ta_none"
    fi
}

# desc: Ensure that we have the requested secret written to a file
# args: $1 (required): The program that we want the secret for
#       $2 (required): The expected location of the file containing the secret
function _check_for_secret() {
    if [[ ! -f "$2" ]]; then
        pretty_print "The expected secret [$1] doesn't exist. You can create it following the below instructions:

    $EDITOR $2
    chmod u=r,go-rwx $2
" "$(tput setaf 3 2> /dev/null || true)" # yellow

        return 1
    fi

    return 0
}

function _check_venv() {
    # ensure that the python venv exists before trying to run the playbook
    if [ ! -d "venv" ]; then
        script_exit "Could not find the Python venv, please run 'make install' and try again." 1
    fi
}

# args: $1 (required) = the playbook file
#       $@ (optional) = args to pass to the ansible-playbook command
function playbook() {
    if [ -z "$1" ]; then
        script_exit "Argument 1: 'playbook' is required." 1
    fi
    local -r PLAYBOOK="$1"
    shift

    _check_venv

    cd "$ROOTDIR/../.."
    # shellcheck source=/dev/null
    source venv/bin/activate

    local ARGS=()
    IFS=" " read -r -a ARGS <<<"$*" # include user-provided params
    ARGS+=("--diff")
    if _check_for_secret "ansible-vault" "$PASSWORD_FILE_FOR_VAULT"; then
        ARGS+=("--vault-password-file" "$PASSWORD_FILE_FOR_VAULT")
    else
        ARGS+=("--ask-vault-password")
    fi
    ARGS+=("--inventory" "hosts.ini")

    printf 'Running ansible-playbook w/ args:\n  %s' "${ARGS[*]}"
    time ansible-playbook "${ARGS[@]}" "ansible/$PLAYBOOK"
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
    read -r -p "Do you want to proceed? y/[n]: " yn

    case $yn in
    [yY][eE][sS] | [yY])
        :
        ;;
    *)
        script_exit "Aborting..." 0
        ;;
    esac
}
