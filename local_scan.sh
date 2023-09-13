#!/bin/bash

# Function to determine the local network
get_local_network() {
  # Use the 'ip' command to get the local network
  local_network=$(ip route | awk 'NR==2 {print $1}' FS=" ")
  echo "$local_network"
}

# Function to scan the local network using Nmap
scan_local_network() {
  local_network="$1"
  
  if [ -z "$local_network" ]; then
    echo "Error: Local network not found."
    exit 1
  fi
  
  echo "Scanning the local network: $local_network"
  
  # Run Nmap to scan the local network
  nmap -sn "$local_network"
}

# Main script
local_network=$(get_local_network)
scan_local_network "$local_network"
