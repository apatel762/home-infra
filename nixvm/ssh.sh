#!/usr/bin/env bash

ssh \
    -o PubkeyAuthentication=no \
    -o UserKnownHostsFile=/dev/null \
    -o StrictHostKeyChecking=no \
    -p 22 \
    root@192.168.122.33
