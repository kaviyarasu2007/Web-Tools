#!/bin/bash

# Subdomain Enumeration & Scanning Automation Script
# Usage: ./run_tools.sh example.com

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check if domain argument is provided
if [ -z "$1" ]; then
    echo -e "${RED}Error: Please provide a domain as an argument${NC}"
    echo "Usage: $0 example.com"
    exit 1
fi

DOMAIN=$1
DATE=$(date +"%Y-%m-%d_%H-%M-%S")
OUTPUT_DIR="scan_results_${DOMAIN}_${DATE}"

# Create output directory
mkdir -p "$OUTPUT_DIR" || { echo -e "${RED}Failed to create output directory${NC}"; exit 1; }

echo -e "${YELLOW}Starting scan for domain: $DOMAIN at $(date)${NC}"
echo -e "${YELLOW}Results will be saved in: $OUTPUT_DIR/${NC}"
echo "--------------------------------------------------"

# Function to check tool availability
check_tool() {
    if ! command -v "$1" &> /dev/null; then
        echo -e "${RED}Error: $1 is not installed or not in PATH${NC}"
        return 1
    fi
    return 0
}

# Run Subfinder
echo -e "${GREEN}[1] Running Subfinder...${NC}"
if check_tool "subfinder"; then
    subfinder -d "$DOMAIN" -o "$OUTPUT_DIR/subfinder_${DOMAIN}_${DATE}.txt"
    echo "Subfinder results saved to $OUTPUT_DIR/subfinder_${DOMAIN}_${DATE}.txt"
else
    echo -e "${RED}Skipping Subfinder${NC}"
fi
echo "--------------------------------------------------"

# Run Assetfinder
echo -e "${GREEN}[2] Running Assetfinder...${NC}"
if check_tool "assetfinder"; then
    assetfinder --subs-only "$DOMAIN" > "$OUTPUT_DIR/assetfinder_${DOMAIN}_${DATE}.txt"
    echo "Assetfinder results saved to $OUTPUT_DIR/assetfinder_${DOMAIN}_${DATE}.txt"
else
    echo -e "${RED}Skipping Assetfinder${NC}"
fi
echo "--------------------------------------------------"

# Combine results from both tools and sort unique
echo -e "${GREEN}[3] Combining and sorting results...${NC}"
cat "$OUTPUT_DIR/subfinder_${DOMAIN}_${DATE}.txt" "$OUTPUT_DIR/assetfinder_${DOMAIN}_${DATE}.txt" 2>/dev/null | sort -u > "$OUTPUT_DIR/all_subdomains_${DOMAIN}_${DATE}.txt"
echo "Combined subdomains saved to $OUTPUT_DIR/all_subdomains_${DOMAIN}_${DATE}.txt"
echo "--------------------------------------------------"

# Run httprobe on found subdomains
echo -e "${GREEN}[4] Running httprobe...${NC}"
if check_tool "httprobe"; then
    cat "$OUTPUT_DIR/all_subdomains_${DOMAIN}_${DATE}.txt" | httprobe > "$OUTPUT_DIR/live_subdomains_${DOMAIN}_${DATE}.txt"
    echo "Live subdomains saved to $OUTPUT_DIR/live_subdomains_${DOMAIN}_${DATE}.txt"
else
    echo -e "${RED}Skipping httprobe${NC}"
fi
echo "--------------------------------------------------"

# Run httpx on live subdomains
echo -e "${GREEN}[5] Running httpx...${NC}"
if check_tool "httpx"; then
    httpx -l "$OUTPUT_DIR/live_subdomains_${DOMAIN}_${DATE}.txt" -title -status-code -tech-detect -o "$OUTPUT_DIR/httpx_results_${DOMAIN}_${DATE}.json" -json
    echo "httpx results saved to $OUTPUT_DIR/httpx_results_${DOMAIN}_${DATE}.json"
else
    echo -e "${RED}Skipping httpx${NC}"
fi
echo "--------------------------------------------------"

# Run Nuclei on live subdomains
echo -e "${GREEN}[6] Running Nuclei...${NC}"
if check_tool "nuclei"; then
    nuclei -l "$OUTPUT_DIR/live_subdomains_${DOMAIN}_${DATE}.txt" -o "$OUTPUT_DIR/nuclei_results_${DOMAIN}_${DATE}.txt"
    echo "Nuclei results saved to $OUTPUT_DIR/nuclei_results_${DOMAIN}_${DATE}.txt"
else
    echo -e "${RED}Skipping Nuclei${NC}"
fi
echo "--------------------------------------------------"

# Final summary
echo -e "${YELLOW}Scan completed at $(date)${NC}"
echo -e "${YELLOW}Results saved in $OUTPUT_DIR/${NC}"
echo -e "${GREEN}Subdomains found: $(wc -l < "$OUTPUT_DIR/all_subdomains_${DOMAIN}_${DATE}.txt")${NC}"
echo -e "${GREEN}Live subdomains: $(wc -l < "$OUTPUT_DIR/live_subdomains_${DOMAIN}_${DATE}.txt")${NC}"

# Optional: Create a compressed archive of results
echo -e "${YELLOW}Creating compressed archive of results...${NC}"
tar -czvf "scan_results_${DOMAIN}_${DATE}.tar.gz" "$OUTPUT_DIR"/
echo -e "${GREEN}Archive created: scan_results_${DOMAIN}_${DATE}.tar.gz${NC}"
