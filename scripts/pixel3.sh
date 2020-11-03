#!/usr/bin/env bash

set -euxo pipefail

export ADB="/home/arjun/Documents/adb-platform-tools/adb"
if [ -f "$ADB" ]; then
    PHONE_IP="192.168.0.2"

    #"$ADB" tcpip 5555
    "$ADB" connect "$PHONE_IP"
    "$ADB" devices

    command -v scrcpy \
        && scrcpy --bit-rate 512K --max-size 1024 --turn-screen-off --stay-awake

    "$ADB" disconnect
    "$ADB" kill-server
fi
