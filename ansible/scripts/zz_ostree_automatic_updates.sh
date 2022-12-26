#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

playbook zz_ostree_automatic_updates.yml "ws"