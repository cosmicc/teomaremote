#!/bin/bash

# Check if the script is run with sudo
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run with sudo or as root."
    exit 1
fi

# Define the file path
file_path="/boot/wpa_supplicant.conf"

# Prompt for SSID
read -p "Enter the SSID (network name): " ssid

# Prompt for PSK (password)
read -s -p "Enter the PSK (password): " psk
echo

# Construct the contents of the file
contents="

network={
 scan_ssid=1
 ssid=\"$ssid\"
 psk=\"$psk\"
}
"

# Write the contents to the file
echo "$contents" >> "$file_path"

# Provide some feedback
if [ -e "$file_path" ]; then
    echo "Wireless network added successfully, rebooting device"
    reboot
else
    echo "Failed to create add wireless network."
fi
