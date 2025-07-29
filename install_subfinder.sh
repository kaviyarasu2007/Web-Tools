#!/bin/bash

# SubFinder Installer with Error Handling
# Author: Your Name
# GitHub: Your GitHub Profile

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[ERROR] Please run with sudo.${NC}"
    exit 1
fi

# Function to handle errors
handle_error() {
    echo -e "${RED}[ERROR] $1${NC}"
    exit 1
}

# Update system
echo -e "${YELLOW}[*] Updating system...${NC}"
apt update -y || handle_error "Failed to update packages"
apt upgrade -y || handle_error "Failed to upgrade packages"

# Install dependencies
echo -e "${YELLOW}[*] Installing dependencies...${NC}"
apt install -y golang git wget || handle_error "Failed to install dependencies"

# Set up Go environment (non-root installation)
echo -e "${YELLOW}[*] Setting up Go environment...${NC}"
export GOPATH=$HOME/go
export PATH=$PATH:$GOPATH/bin
echo 'export GOPATH=$HOME/go' >> ~/.bashrc
echo 'export PATH=$PATH:$GOPATH/bin' >> ~/.bashrc
source ~/.bashrc

# Install SubFinder
echo -e "${YELLOW}[*] Installing SubFinder...${NC}"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest || handle_error "Failed to install SubFinder"

# Verify installation
echo -e "${YELLOW}[*] Verifying installation...${NC}"
if [ -f "$GOPATH/bin/subfinder" ]; then
    # Create symlink to /usr/local/bin for global access
    sudo ln -sf $GOPATH/bin/subfinder /usr/local/bin/subfinder || echo -e "${YELLOW}[!] Could not create symlink (may need manual setup)${NC}"
    
    # Final verification
    if command -v subfinder &> /dev/null; then
        echo -e "${GREEN}[+] SubFinder installed successfully!${NC}"
        echo -e "${GREEN}[+] Version: $(subfinder -version)${NC}"
    else
        echo -e "${YELLOW}[!] SubFinder installed but not in PATH. Try: source ~/.bashrc${NC}"
        echo -e "${YELLOW}[!] Or run directly from: $GOPATH/bin/subfinder${NC}"
    fi
else
    handle_error "SubFinder binary not found in $GOPATH/bin"
fi

# API key configuration reminder
echo -e "\n${YELLOW}[!] For best results, add API keys to:~/.config/subfinder/provider-config.yaml${NC}"
echo -e "${YELLOW}    See: https://github.com/projectdiscovery/subfinder#post-installation-steps${NC}"
