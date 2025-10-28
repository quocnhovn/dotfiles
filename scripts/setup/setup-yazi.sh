#!/bin/bash

# Setup Yazi file manager with plugins and themes
# Based on best practices from dotfiles-docs.vercel.app

LOG_FILE="/tmp/yazi-setup.log"

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
log "📁 Setting up Yazi file manager with plugins..."

# First ensure required dependencies are installed
log "Installing required dependencies..."
sudo apt update
sudo apt install -y git curl

# Check if yazi is installed
if ! command -v yazi &> /dev/null; then
    log "Installing Yazi..."

    # Try installing from apt first
    if sudo apt install -y yazi 2>/dev/null; then
        log "✅ Yazi installed from apt"
    else
        warning "Yazi not available in apt, installing from cargo..."

        # Install rust if not available
        if ! command -v cargo &> /dev/null; then
            log "Installing Rust/Cargo..."
            curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
            source "$HOME/.cargo/env"
            export PATH="$HOME/.cargo/bin:$PATH"

            # Verify cargo installation
            if ! command -v cargo &> /dev/null; then
                error "Failed to install Rust/Cargo"
                exit 1
            fi
        fi

        # Install yazi via cargo
        if command -v cargo &> /dev/null; then
            cargo install --locked yazi-fm yazi-cli
            log "✅ Yazi installed from cargo"
        else
            error "Cargo not available after installation attempt"
            exit 1
        fi
    fi
else
    log "Yazi already installed: $(yazi --version)"
fi

# Create yazi config directory
mkdir -p ~/.config/yazi/plugins
mkdir -p ~/.config/yazi/flavors

# Install plugins using ya package manager
log "Installing Yazi plugins..."

# Check if ya command exists (comes with yazi-cli)
if command -v ya &> /dev/null; then
    # Install plugins with ya package manager
    ya pack -a yazi-rs/plugins:full-border 2>/dev/null || warning "Failed to add full-border plugin"
    ya pack -a Rolv-Apneseth/starship.yazi 2>/dev/null || warning "Failed to add starship plugin"
    ya pack -a yazi-rs/plugins:git 2>/dev/null || warning "Failed to add git plugin"

    # Install plugins
    ya pack -i 2>/dev/null || warning "Failed to install some plugins"
    log "✅ Plugins installed with ya package manager"
else
    warning "ya command not found, installing plugins manually..."

    # Ensure git is available for manual installation
    if ! command -v git &> /dev/null; then
        error "Git is required for manual plugin installation but not found"
        exit 1
    fi

    # Manual plugin installation
    log "Installing full-border plugin..."
    if [ ! -d ~/.config/yazi/plugins/full-border.yazi ]; then
        git clone https://github.com/yazi-rs/plugins.git /tmp/yazi-plugins 2>/dev/null || {
            error "Failed to clone yazi plugins repository"
            exit 1
        }
        cp -r /tmp/yazi-plugins/full-border.yazi ~/.config/yazi/plugins/ 2>/dev/null || warning "Failed to copy full-border plugin"
    fi

    log "Installing git plugin..."
    if [ ! -d ~/.config/yazi/plugins/git.yazi ]; then
        cp -r /tmp/yazi-plugins/git.yazi ~/.config/yazi/plugins/ 2>/dev/null || warning "Failed to copy git plugin"
    fi

    log "Installing starship plugin..."
    if [ ! -d ~/.config/yazi/plugins/starship.yazi ]; then
        git clone https://github.com/Rolv-Apneseth/starship.yazi.git ~/.config/yazi/plugins/starship.yazi 2>/dev/null || warning "Failed to install starship plugin"
    fi

    log "Installing searchjump plugin..."
    if [ ! -d ~/.config/yazi/plugins/searchjump.yazi ]; then
        git clone https://gitee.com/DreamMaoMao/searchjump.yazi.git ~/.config/yazi/plugins/searchjump.yazi 2>/dev/null || warning "Failed to install searchjump plugin"
    fi

    # Clean up
    [ -d /tmp/yazi-plugins ] && rm -rf /tmp/yazi-plugins

    log "✅ Plugins installed manually"
fi

# Install Catppuccin theme/flavor
log "Installing Catppuccin theme..."
if [ ! -d ~/.config/yazi/flavors/catppuccin-macchiato.yazi ]; then
    if command -v git &> /dev/null; then
        git clone https://github.com/catppuccin/yazi.git /tmp/catppuccin-yazi 2>/dev/null || {
            error "Failed to clone Catppuccin theme repository"
            exit 1
        }
        cp -r /tmp/catppuccin-yazi/themes/macchiato.yazi ~/.config/yazi/flavors/catppuccin-macchiato.yazi 2>/dev/null || {
            error "Failed to copy Catppuccin theme"
            exit 1
        }
        rm -rf /tmp/catppuccin-yazi
        log "✅ Catppuccin theme installed"
    else
        error "Git is required for theme installation but not found"
        exit 1
    fi
else
    log "Catppuccin theme already installed"
fi

log "✅ Yazi setup completed!"

# Display summary
echo
echo "🎉 Yazi Setup Summary:"
echo "===================="
echo "• Yazi version: $(yazi --version 2>/dev/null || echo 'Not installed')"
echo "• Config directory: ~/.config/yazi"
echo
echo "📦 Installed plugins:"
echo "  • full-border - Enhanced borders"
echo "  • git - Git integration"
echo "  • starship - Starship prompt integration"
echo "  • searchjump - Enhanced search navigation"
echo
echo "🎨 Installed themes:"
echo "  • catppuccin-macchiato - Beautiful theme"
echo
echo "🔑 Key bindings:"
echo "  • Enter/l - Enter directory"
echo "  • h - Go back"
echo "  • j/k - Navigate up/down"
echo "  • Space - Select files"
echo "  • y - Copy files"
echo "  • p - Paste files"
echo "  • d - Delete files"
echo "  • a - Create file/directory"
echo "  • r - Rename"
echo "  • / - Search"
echo "  • z - Jump with zoxide"
echo "  • q - Quit"
echo
echo "💡 Start yazi with: yazi [directory]"
