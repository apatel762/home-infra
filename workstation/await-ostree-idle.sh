#!/usr/bin/env bash

# The `rpm-ostree status` command output looks something like below.
# The first line is what we're interested in. When it says 'State: idle'
# it means that we can go ahead with running the playbook (which will
# be using the `rpm-ostree` command). If it isn't idle, then we have to
# wait
#
#   State: idle
#   Deployments:
#   ● fedora:fedora/35/x86_64/silverblue
#                      Version: 35.20220219.0 (2022-02-19T00:46:32Z)
#                   BaseCommit: 8fd62bd20c832d1cf6c011242590be29378f5bb6458793a1ffa278bc1ccdf6ba
#                 GPGSignature: Valid signature by 787EA6AE1147EEE56C40B30CDB4639719867C58F
#              LayeredPackages: mozilla-ublock-origin
#
#     fedora:fedora/35/x86_64/silverblue
#                      Version: 35.20220219.0 (2022-02-19T00:46:32Z)
#                       Commit: 8fd62bd20c832d1cf6c011242590be29378f5bb6458793a1ffa278bc1ccdf6ba
#                 GPGSignature: Valid signature by 787EA6AE1147EEE56C40B30CDB4639719867C58F
#

while ! $(rpm-ostree status| grep ^State | grep idle > /dev/null) ; do \
    echo "Waiting for rpm-ostree to be idle..." \
    sleep 3 \
done;