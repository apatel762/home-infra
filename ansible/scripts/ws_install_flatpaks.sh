#!/usr/bin/env bash

# shellcheck source=/dev/null
source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

playbook ws_install_flatpaks.yml "$@"