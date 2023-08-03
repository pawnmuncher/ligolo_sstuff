#!/bin/bash

# Function to check if the TUN/TAP device exists and prompt for removal
function check_tuntap_and_prompt() {
    if ip tuntap show dev ligolo &> /dev/null; then
        read -p "TUN/TAP device 'ligolo' already exists. Do you want to remove it? (y/n): " choice
        if [ "$choice" = "y" ] || [ "$choice" = "Y" ]; then
            # Remove the existing TUN/TAP device
            sudo ip tuntap delete mode tun dev ligolo
        else
            echo "Using existing TUN/TAP device 'ligolo'."
        fi
    fi
}

# Function to handle user input and error checking for IP address or CIDR
function get_ip_or_cidr() {
    read -p "Please enter IP address and/or CIDR (172.17.0.0/24 etc) for ligolo to route for you (or type 'done' to finish): " ip_or_cidr

    # Check if the input is 'done', if so, exit the loop
    if [ "$ip_or_cidr" = "done" ]; then
        return 1
    fi

    # Check if the input is a valid IP address or CIDR
    if ! valid_ip_or_cidr "$ip_or_cidr"; then
        echo "Error: Invalid IP address or CIDR format. Please enter a valid IP address or CIDR."
        get_ip_or_cidr
    else
        # Add the IP address or CIDR to the array
        ip_or_cidrs+=("$ip_or_cidr")
    fi
}

# Function to validate IP address or CIDR
function valid_ip_or_cidr() {
    local ip_or_cidr=$1
    if [[ $ip_or_cidr =~ ^([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+(/[0-9]+)?)$ ]]; then
        return 0
    else
        return 1
    fi
}

# Check if the script is running with superuser privileges (sudo)
if [ "$EUID" -ne 0 ]; then
    echo "This script needs to be run with superuser privileges (sudo). Please try again with sudo."
    exit 1
fi

# Prompt for the username
read -p "Please enter the username for the TUN/TAP device (the user who will run the proxy): " CURRENT_USER

# Prompt for the path to the ligolo directory
read -p "Please enter the full path to the ligolo directory: " ligolo_directory

# Check and prompt to remove existing TUN/TAP device
check_tuntap_and_prompt

# Create a TUN/TAP device and bring it up
ip tuntap add user "$CURRENT_USER" mode tun ligolo
sleep 1
ip link set ligolo up
sleep 1

# Ask for IP addresses or CIDRs and add corresponding routes
ip_or_cidrs=()

while get_ip_or_cidr; do :; done

# Add all IP addresses and CIDRs to the routing table in a single command
for ip_or_cidr in "${ip_or_cidrs[@]}"; do
    ip route add "$ip_or_cidr" dev ligolo
done

# Step 3: Navigate to the ligolo tools directory and run the proxy with a self-signed certificate
cd "$ligolo_directory"
./proxy -selfcert
