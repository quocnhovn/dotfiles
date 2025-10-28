#!/bin/bash

# Quick Daily Update Script
# Fast updates for daily maintenance

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}🚀 Quick Daily Update${NC}"

# System packages
echo "📦 Updating system packages..."
sudo apt update && sudo apt upgrade -y

# Topgrade for comprehensive updates
if command -v topgrade >/dev/null 2>&1; then
    echo "⚡ Running Topgrade..."
    topgrade --yes
else
    echo "❌ Topgrade not installed, run ./update.sh for full setup"
fi

# Clean up
echo "🧹 Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean

echo -e "${GREEN}✅ Quick update completed!${NC}"
echo "💡 For full update, run: ./update.sh"
