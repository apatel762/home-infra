#!/bin/bash

# echo an error message and exit the script
oops() {
    echo "$0:" "$@" >&2
    exit 1
}

# args: $1 = a binary you want to require e.g. tar, gpg, mail
#       $2 = a message briefly describing what you need the binary for
require() {
    command -v "$1" > /dev/null 2>&1 \
        || oops "you do not have '$1' installed or its not in your PATH; needed for: $2"
}

require ansible
require ansible-playbook
require ansible-galaxy

# gets the directory of this script
ROOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# install required ansible community modules
ansible-galaxy collection install -r "$ROOTDIR/requirements.yml"

# ensure that the vault password file exists
VAULT_PASSWORD_FILE="$ROOTDIR/vault-password-file"
if [[ ! -f "$VAULT_PASSWORD_FILE" ]]; then
    echo "No password file exists. Do the following:"
    echo ""
    echo "  $EDITOR $VAULT_PASSWORD_FILE"
    echo "  chmod u=r,go-rwx $VAULT_PASSWORD_FILE"
    echo ""
    oops "Please create $VAULT_PASSWORD_FILE with strict permissions and re-run this script."
fi

# use `set -x` to log all commands from here onwards
set -x
HOSTS="$ROOTDIR/hosts.ini"
PLAYBOOK="$ROOTDIR/playbook.yml"

# runs Ansible playbook using our user.
ansible-playbook \
    --vault-password-file "$VAULT_PASSWORD_FILE" \
    --inventory "$HOSTS" "$PLAYBOOK" \
    --ask-become-pass

exit 0
