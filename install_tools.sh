#!/bin/bash

# Automation script for installing subdomain enumeration tools
# Give this script execute permission: chmod +x install_all_tools.sh

# Define colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Array of installation scripts
INSTALL_SCRIPTS=(
    "install_subfinder.sh"
    "install_assetfinder.sh"
    "install_httpx.sh"
    "install_httprobe.sh"
    "install_nuclei.sh"
)

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to run installation script
run_installation() {
    local script=$1
    local tool_name=$(echo $script | sed 's/install_//' | sed 's/.sh//')
    
    echo -e "${YELLOW}Starting installation of ${tool_name}...${NC}"
    
    # Give execute permission to the script
    chmod +x "$script"
    
    # Run the script and capture output
    if ./"$script"; then
        echo -e "${GREEN}${tool_name} installation completed successfully${NC}"
        return 0
    else
        echo -e "${RED}${tool_name} installation failed${NC}"
        return 1
    fi
}

# Main installation process
echo -e "${YELLOW}Starting installation of all tools...${NC}"
echo "=========================================="

success_count=0
fail_count=0

for script in "${INSTALL_SCRIPTS[@]}"; do
    if [ -f "$script" ]; then
        if run_installation "$script"; then
            ((success_count++))
        else
            ((fail_count++))
        fi
    else
        echo -e "${RED}Error: Installation script $script not found${NC}"
        ((fail_count++))
    fi
    echo "------------------------------------------"
done

# Summary
echo -e "${YELLOW}Installation Summary:${NC}"
echo -e "${GREEN}Successful installations: $success_count${NC}"
echo -e "${RED}Failed installations: $fail_count${NC}"

if [ $fail_count -eq 0 ]; then
    echo -e "${GREEN}All tools installed successfully!${NC}"
else
    echo -e "${YELLOW}Some installations failed. Check the logs above for details.${NC}"
fi

# Verify tools are installed
echo -e "\n${YELLOW}Verifying installed tools...${NC}"
for script in "${INSTALL_SCRIPTS[@]}"; do
    tool_name=$(echo $script | sed 's/install_//' | sed 's/.sh//')
    if command_exists "$tool_name"; then
        echo -e "${GREEN}$tool_name is installed and available in PATH${NC}"
    else
        echo -e "${RED}$tool_name is not found in PATH${NC}"
    fi
done
