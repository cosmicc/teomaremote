#!/bin/bash

if [ "$EUID" -ne 0 ]; then
    echo "Error: This script must be run as root."
    exit 1
fi

if [ -n "$1" ]; then
    echo -e "$1\n$1" | smbpasswd -s -a tsadmin
else
    echo -n "tsadmin user "
    smbpasswd -a tsadmin
fi
