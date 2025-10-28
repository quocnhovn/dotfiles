#!/bin/bash

# Fish shell setup for Deepin OS 25
# Based on best practices from dotfiles-docs.vercel.app

LOG_FILE="/tmp/fish-setup.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

log() {
    echo -e "${GREEN}[$(date +'%Y-%m-%d %H:%M:%S')]${NC} $1" | tee -a "$LOG_FILE"
}

error() {
    echo -e "${RED}[ERROR]${NC} $1" | tee -a "$LOG_FILE"
}

warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1" | tee -a "$LOG_FILE"
}

info() {
    echo -e "${BLUE}[INFO]${NC} $1" | tee -a "$LOG_FILE"
}

# Start setup
log "🐟 Starting Fish shell setup for Deepin OS 25..."

# Install required dependencies first
log "Installing required dependencies..."
sudo apt update
sudo apt install -y curl

# Install Fish shell
if ! command -v fish &> /dev/null; then
    log "Installing Fish shell..."
    sudo apt install -y fish
else
    log "Fish shell already installed"
fi

# Install Fisher plugin manager
log "Installing Fisher plugin manager..."
if ! command -v curl &> /dev/null; then
    error "curl is required but not installed"
    exit 1
fi

fish -c "curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher" 2>/dev/null || {
    warning "Failed to install Fisher, trying alternative method..."
    fish -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher" 2>/dev/null || {
        error "Failed to install Fisher plugin manager"
        exit 1
    }
}

# Install Starship prompt
if ! command -v starship &> /dev/null; then
    log "Installing Starship prompt..."
    if command -v curl &> /dev/null; then
        curl -sS https://starship.rs/install.sh | sh -s -- -y
    else
        error "curl is required for Starship installation"
        exit 1
    fi
else
    log "Starship already installed"
fi

# Install Vivid for LS_COLORS (if available in apt)
if apt list --installed vivid 2>/dev/null | grep -q vivid; then
    log "Vivid already installed"
else
    log "Attempting to install vivid..."
    sudo apt install -y vivid || {
        warning "Vivid not available in apt, installing from GitHub releases..."

        # Download latest vivid release
        VIVID_VERSION=$(curl -s https://api.github.com/repos/sharkdp/vivid/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
        if [ -n "$VIVID_VERSION" ]; then
            wget -O /tmp/vivid.deb "https://github.com/sharkdp/vivid/releases/download/${VIVID_VERSION}/vivid_${VIVID_VERSION#v}_amd64.deb"
            sudo dpkg -i /tmp/vivid.deb || sudo apt --fix-broken install -y
        else
            warning "Could not install vivid"
        fi
    }
fi

log "✅ Fish shell setup completed!"
log "📝 Next: Configure Fish with plugins and settings"

# Display installation summary
echo
echo "🎉 Fish Shell Installation Summary:"
echo "=================================="
echo "• Fish shell: $(fish --version 2>/dev/null || echo 'Not installed')"
echo "• Fisher: $(fish -c 'fisher --version' 2>/dev/null || echo 'Not installed')"
echo "• Starship: $(starship --version 2>/dev/null || echo 'Not installed')"
echo "• Vivid: $(vivid --version 2>/dev/null || echo 'Not installed')"
echo
echo "📚 Next steps:"
echo "1. Configure Fish plugins and settings"
echo "2. Set Fish as default shell (optional)"
echo "3. Setup Fish abbreviations and functions"
