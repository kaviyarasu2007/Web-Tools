#!/bin/bash

# Nuclei Installation Script
# Installs the latest version of Nuclei and its templates

# Check if Go is installed (required for some Nuclei functionality)
if ! command -v go &> /dev/null; then
    echo "Warning: Go is not installed. Some Nuclei features may require Go."
fi

# Install or update Nuclei
echo "[+] Installing/Updating Nuclei..."
if ! command -v nuclei &> /dev/null; then
    # Fresh installation
    go install -v github.com/projectdiscovery/nuclei/v2/cmd/nuclei@latest
    echo "[+] Nuclei installed successfully!"
else
    # Update existing installation
    nuclei -update
    echo "[+] Nuclei updated successfully!"
fi

# Install/update templates
echo "[+] Installing/Updating Nuclei templates..."
nuclei -update-templates

# Verify installation
echo ""
echo "[+] Installation complete!"
echo "[+] Nuclei version: $(nuclei -version)"
echo ""
echo "[!] Basic usage examples:"
echo "    nuclei -u https://example.com"
echo "    nuclei -list targets.txt -t cves/"
echo "    nuclei -u https://example.com -t vulnerabilities/"

# Add to PATH if not already present
if [[ ":$PATH:" != *":$HOME/go/bin:"* ]]; then
    echo ""
    echo "[!] Add Nuclei to your PATH:"
    echo "    echo 'export PATH=\"\$PATH:\$HOME/go/bin\"' >> ~/.bashrc"
    echo "    source ~/.bashrc"
fi
