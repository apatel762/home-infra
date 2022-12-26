#!/usr/bin/env bash

source "$(dirname "${BASH_SOURCE[0]}")/_common.sh"

playbook hs_bootstrap_ssh.yml "hs"