#!/usr/bin/bash

command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if assetfinder is installed; if not, install it
if ! command_exists "assetfinder"; then
    echo "Installing assetfinder..."
    sudo apt install -y assetfinder
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install assetfinder."
        exit 1
    fi
fi

# Check if httprobe is installed; if not, install it
if ! command_exists "httprobe"; then
    echo "Installing httprobe..."
    sudo apt install -y httprobe
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install httprobe."
        exit 1
    fi
fi

# Display ASCII art in red
echo -e "\e[31m
███████ ██    ██ ██████  ██████   ██████  ███    ███  █████  ██ ███    ██
██      ██    ██ ██   ██ ██   ██ ██    ██ ████  ████ ██   ██ ██ ████   ██
███████ ██    ██ ██████  ██   ██ ██    ██ ██ ████ ██ ███████ ██ ██ ██  ██
     ██ ██    ██ ██   ██ ██   ██ ██    ██ ██  ██  ██ ██   ██ ██ ██  ██ ██
███████  ██████  ██████  ██████   ██████  ██      ██ ██   ██ ██ ██   ████
===========================================================================
      
\e[0m"

# Prompt user for domain name
read -p "Enter the Domain: " var

# Validate domain name
if [[ -z "$var" ]]; then
    echo "Error: Domain name cannot be empty."
    exit 1
fi

# Perform subdomain scanning
echo "Scanning subdomains for $var..."
echo ""
assetfinder "$var" > list
wc -l list > no1
cat list | httprobe > live
sort -u live > sorted
cat sorted

# Clean up temporary files
rm -f list live sorted no1
