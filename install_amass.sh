#!/bin/bash
# Run Amass
amass enum -df domains.txt -o amass_results.txt -config ~/.config/amass/config.ini

# Push to GitHub
git add amass_results.txt
git commit -m "Automated Amass results - $(date)"
git push origin main
