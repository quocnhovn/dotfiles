#!/bin/bash

# Version Check Script
# Check versions of all installed development tools

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_version() {
    local tool=$1
    local command=$2
    local description=$3

    if command -v $tool >/dev/null 2>&1; then
        version=$(eval $command 2>/dev/null || echo "Unknown")
        echo -e "${GREEN}✅ $description:${NC} $version"
    else
        echo -e "${RED}❌ $description:${NC} Not installed"
    fi
}

echo -e "${BLUE}🔍 Development Environment Version Check${NC}"
echo "============================================"

# System
echo -e "\n${YELLOW}📦 System Information:${NC}"
print_version "lsb_release" "lsb_release -d | cut -f2" "OS"
print_version "uname" "uname -r" "Kernel"

# Core Tools
echo -e "\n${YELLOW}🛠️ Core Development Tools:${NC}"
print_version "git" "git --version" "Git"
print_version "curl" "curl --version | head -1" "cURL"
print_version "wget" "wget --version | head -1" "Wget"

# Shells
echo -e "\n${YELLOW}🐚 Shells:${NC}"
print_version "bash" "bash --version | head -1" "Bash"
print_version "fish" "fish --version" "Fish Shell"
print_version "starship" "starship --version" "Starship Prompt"

# Modern CLI Tools
echo -e "\n${YELLOW}⚡ Modern CLI Tools:${NC}"
print_version "exa" "exa --version | head -1" "Exa (ls replacement)"
print_version "bat" "bat --version" "Bat (cat replacement)"
print_version "fd" "fd --version" "fd (find replacement)"
print_version "rg" "rg --version | head -1" "Ripgrep (grep replacement)"
print_version "fzf" "fzf --version" "FZF (fuzzy finder)"
print_version "zoxide" "zoxide --version" "Zoxide (cd replacement)"
print_version "yazi" "yazi --version" "Yazi (file manager)"

# Editors
echo -e "\n${YELLOW}📝 Editors:${NC}"
print_version "nvim" "nvim --version | head -1" "Neovim"
print_version "code" "code --version | head -1" "VS Code"
print_version "bob" "bob --version" "Bob (Neovim version manager)"

# Programming Languages
echo -e "\n${YELLOW}🔤 Programming Languages:${NC}"
print_version "node" "node --version" "Node.js"
print_version "npm" "npm --version" "NPM"
print_version "nvm" "nvm --version" "NVM"
print_version "go" "go version" "Go"
print_version "php" "php --version | head -1" "PHP"
print_version "composer" "composer --version" "Composer"
print_version "python3" "python3 --version" "Python 3"
print_version "pip3" "pip3 --version" "Pip 3"
print_version "rustc" "rustc --version" "Rust"
print_version "cargo" "cargo --version" "Cargo"

# Containerization
echo -e "\n${YELLOW}🐳 Containerization:${NC}"
print_version "docker" "docker --version" "Docker"
print_version "docker-compose" "docker-compose --version" "Docker Compose"

# Terminal Multiplexer
echo -e "\n${YELLOW}🖥️ Terminal Tools:${NC}"
print_version "tmux" "tmux -V" "Tmux"
print_version "htop" "htop --version | head -1" "Htop"

# System Utilities
echo -e "\n${YELLOW}🔧 System Utilities:${NC}"
print_version "topgrade" "topgrade --version" "Topgrade"
print_version "tlp" "tlp-stat -s | head -1" "TLP (power management)"
print_version "auto-cpufreq" "auto-cpufreq --version" "Auto-cpufreq"

# Package Managers
echo -e "\n${YELLOW}📦 Package Managers:${NC}"
print_version "apt" "apt --version | head -1" "APT"
print_version "snap" "snap version | head -1" "Snap"
print_version "flatpak" "flatpak --version" "Flatpak"

echo -e "\n${BLUE}🎯 Quick Commands to Update:${NC}"
echo "• Full update: ./update.sh"
echo "• Quick update: ./quick-update.sh"
echo "• System only: sudo apt update && sudo apt upgrade"
echo "• Universal: topgrade --yes"

echo -e "\n${GREEN}✨ Version check completed!${NC}"
