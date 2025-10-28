#!/bin/bash

# Setup TPM (Tmux Plugin Manager) and plugins
# Based on best practices from dotfiles-docs.vercel.app

LOG_FILE="/tmp/tmux-setup.log"

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
log "🔧 Setting up Tmux with TPM and plugins..."

# Create tmux config directory if it doesn't exist
mkdir -p ~/.config/tmux/plugins

# Install TPM if not already installed
if [ ! -d ~/.config/tmux/plugins/tpm ]; then
    log "Installing TPM (Tmux Plugin Manager)..."
    git clone https://github.com/tmux-plugins/tpm ~/.config/tmux/plugins/tpm
else
    log "TPM already installed"
fi

# Check if tmux is installed
if ! command -v tmux &> /dev/null; then
    log "Installing tmux..."
    sudo apt update
    sudo apt install -y tmux
fi

# Copy tmux configuration
log "Setting up tmux configuration..."
mkdir -p ~/.config/tmux
cp ~/.config/tmux/.tmux.conf ~/.tmux.conf 2>/dev/null || {
    warning "Could not find tmux config to copy"
}

# Create a symlink if using XDG config directory
if [ -f ~/.config/tmux/.tmux.conf ]; then
    ln -sf ~/.config/tmux/.tmux.conf ~/.tmux.conf
    log "Created symlink for tmux config"
fi

# Install plugins
log "Installing tmux plugins..."

# Start a tmux session in the background to install plugins
tmux new-session -d -s plugin_install
sleep 2

# Install plugins using TPM
tmux send-keys -t plugin_install '~/.config/tmux/plugins/tpm/bin/install_plugins' Enter
sleep 5

# Kill the session
tmux kill-session -t plugin_install

log "✅ Tmux setup completed!"

# Display summary
echo
echo "🎉 Tmux Setup Summary:"
echo "===================="
echo "• Tmux version: $(tmux -V 2>/dev/null || echo 'Not installed')"
echo "• TPM installed: $([ -d ~/.config/tmux/plugins/tpm ] && echo 'Yes' || echo 'No')"
echo "• Configuration: ~/.tmux.conf"
echo
echo "📚 Installed plugins:"
echo "  • tmux-sensible - Sensible defaults"
echo "  • tmux-resurrect - Session restoration"
echo "  • tmux-continuum - Automatic session saving"
echo "  • tmux-yank - System clipboard integration"
echo "  • vim-tmux-navigator - Seamless vim-tmux navigation"
echo "  • catppuccin/tmux - Beautiful theme"
echo "  • tmux-fingers - Copy text with hints"
echo
echo "🔑 Key bindings:"
echo "  • Prefix: Ctrl-a"
echo "  • Split horizontal: Prefix + |"
echo "  • Split vertical: Prefix + -"
echo "  • Reload config: Prefix + r"
echo "  • Install plugins: Prefix + I"
echo "  • Update plugins: Prefix + U"
echo "  • Remove plugins: Prefix + alt + u"
echo
echo "💡 Start tmux with: tmux new -s mysession"
