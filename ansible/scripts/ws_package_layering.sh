#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

# if something else is using ostree, we should wait for that to complete before
# running our package layering playbook
await_ostree_idle

playbook ws_package_layering.yml "ws"