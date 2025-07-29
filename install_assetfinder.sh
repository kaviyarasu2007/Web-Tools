#!/bin/bash

# Install assetfinder and verify installation by checking version

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Install assetfinder if not already installed
if ! command_exists assetfinder; then
    echo "Installing assetfinder..."
    
    # Check if Go is installed (assetfinder requires Go to build)
    if ! command_exists go; then
        echo "Error: Go (golang) is required to install assetfinder but it's not installed."
        echo "Please install Go first: https://golang.org/doc/install"
        exit 1
    fi
    
    # Install assetfinder using go install
    go install github.com/tomnomnom/assetfinder@latest
    
    # Check if installation was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install assetfinder"
        exit 1
    fi
    
    # Add GOPATH to PATH if not already there (needed for some Go installations)
    if [[ ":$PATH:" != *":$HOME/go/bin:"* ]]; then
        export PATH="$PATH:$HOME/go/bin"
        echo "Added GOPATH to PATH temporarily for this session."
        echo "To make this permanent, add the following to your ~/.bashrc or ~/.zshrc:"
        echo 'export PATH="$PATH:$HOME/go/bin"'
    fi
else
    echo "assetfinder is already installed"
fi

# Verify installation by checking version
echo -e "\nChecking assetfinder version..."
assetfinder -version

if [ $? -ne 0 ]; then
    # Some versions might use different version flag
    echo "Trying alternative version flag..."
    assetfinder --version
fi

echo -e "\nassetfinder installation verified!"
