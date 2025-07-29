#!/bin/bash

# Install SubFinder with Dependencies - Bash Script
# Author: Your Name
# GitHub: Your GitHub Profile

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

# Check if running as root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}[ERROR] Please run as root or with sudo.${NC}"
    exit 1
fi

# Update system
echo -e "${YELLOW}[*] Updating system packages...${NC}"
apt update -y && apt upgrade -y

# Install dependencies
echo -e "${YELLOW}[*] Installing dependencies (Go, git, wget)...${NC}"
apt install -y golang git wget

# Install SubFinder
echo -e "${YELLOW}[*] Installing SubFinder...${NC}"
go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest

# Add Go binaries to PATH
echo -e "${YELLOW}[*] Adding Go binaries to PATH...${NC}"
export PATH=$PATH:/root/go/bin
echo 'export PATH=$PATH:/root/go/bin' >> ~/.bashrc
source ~/.bashrc

# Verify installation
if command -v subfinder &> /dev/null; then
    echo -e "${GREEN}[+] SubFinder installed successfully!${NC}"
    echo -e "${GREEN}[+] Run: subfinder -h for usage.${NC}"
else
    echo -e "${RED}[ERROR] SubFinder installation failed.${NC}"
    exit 1
fi

# Optional: Configure API keys for better results
echo -e "${YELLOW}[!] For better results, add API keys to ~/.config/subfinder/provider-config.yaml${NC}"
