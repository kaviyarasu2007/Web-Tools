#!/bin/bash

# httprobe Installation Script
# Installs httprobe for checking active HTTP servers

# Check if Go is installed
if ! command -v go &> /dev/null; then
    echo "[-] Error: Go is not installed but required for httprobe"
    echo "[-] Install Go first: https://golang.org/doc/install"
    exit 1
fi

# Install httprobe
echo "[+] Installing httprobe..."
go install github.com/tomnomnom/httprobe@latest

# Verify installation
if ! command -v ~/go/bin/httprobe &> /dev/null; then
    echo "[-] Installation failed!"
    exit 1
fi

# Add to PATH if not already present
if [[ ":$PATH:" != *":$HOME/go/bin:"* ]]; then
    echo "[+] Adding Go binaries to your PATH..."
    echo 'export PATH="$PATH:$HOME/go/bin"' >> ~/.bashrc
    source ~/.bashrc
fi

echo ""
echo "[+] httprobe installed successfully!"
echo "[+] Location: $(which httprobe)"
echo ""
echo "[!] Basic usage examples:"
echo "    cat domains.txt | httprobe"
echo "    cat domains.txt | httprobe -p http:81 -p https:8443"
echo "    cat domains.txt | httprobe -c 50"
echo ""
echo "[!] Common combinations:"
echo "    subfinder -d example.com | httprobe | tee alive.txt"
echo "    cat domains.txt | httprobe | sort -u > alive_hosts.txt"
