#!/usr/bin/env bash

# ---------------------------------------------------------------------------
# HELPER FUNCTIONS

# echo an error message and exit the script
oops() {
    echo "$0:" "$@" >&2
    exit 1
}

log() {
    echo "$0:" "$1"
}

# args: $1 = a binary you want to require e.g. tar, gpg, mail
#       $2 = a message briefly describing what you need the binary for
require() {
    log "checking that '$1' is installed..."
    command -v "$1" > /dev/null 2>&1 \
        || oops "you do not have '$1' installed; needed for: $2"
}

# ---------------------------------------------------------------------------
# PRE-REQUISITES FOR USING THIS PROJECT

require python "for creating the virtual env that the scripts will work in"

# ---------------------------------------------------------------------------
# VARIABLES & FUNCTIONS

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

cleanup() {
    log "No cleanup to do... exiting."
}

trap cleanup EXIT

create_venv_if_not_present() {
    log "checking for venv..."
    if [ ! -d "venv" ]; then
        log "could not find a venv"

        # we couldn't find a virtual environment, so now we'll create one
        # ...but first, ensure that we are using Python 3.8+
        if echo "$(python --version)" | egrep 'Python 3\.(([89])|([0-9]{2}))'; then
            log "creating venv with version: $(python --version)"
            python -m venv venv
        else
            oops "Installation failed! You must have Python 3.8+"
        fi

        source venv/bin/activate
        pip install --upgrade pip
        pip install -r "$DIR/requirements.txt"
    else
        log "venv already exists - skipping"
    fi
}

check_freshly_installed_packages() {
    # these should all be installed now
    require ansible
    require ansible-playbook
    require ansible-galaxy
}

install_ansible_galaxy_requirements() {
    ansible-galaxy collection install -r "$DIR/requirements.yml"
}

# ---------------------------------------------------------------------------
# MAIN SCRIPT EXECUTION

create_venv_if_not_present
check_freshly_installed_packages
install_ansible_galaxy_requirements

log "Check the 'group_vars/all' file before running the playbook"

# ---------------------------------------------------------------------------
# CLEAN EXIT

exit 0
