#!/bin/sh

# HTTPX Installation Script
# Installs the Python httpx HTTP client package

# Check if Python3 is available
if ! command -v python3 >/dev/null 2>&1; then
    echo "Error: Python3 is required but not installed." >&2
    exit 1
fi

# Check if pip3 is available
if ! command -v pip3 >/dev/null 2>&1; then
    echo "Error: pip3 is required but not found." >&2
    echo "Try installing with: sudo apt install python3-pip" >&2
    exit 1
fi

echo "Installing HTTPX HTTP client..."

# Install httpx using pip
if pip3 install --user httpx; then
    echo ""
    echo "HTTPX installed successfully!"
    echo "Version info: $(python3 -c 'import httpx; print(httpx.__version__)')"
    echo ""
    echo "Basic usage example:"
    echo "  python3 -c \"import httpx; print(httpx.get('https://httpbin.org/get').json())\""
else
    echo ""
    echo "Failed to install HTTPX." >&2
    exit 1
fi
