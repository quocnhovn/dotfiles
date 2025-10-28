#!/bin/bash

# Link Configuration Files
# This script creates symbolic links for all configuration files

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[LINK]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

# Function to create symbolic link with backup
link_config() {
    local source="$1"
    local target="$2"
    local target_dir=$(dirname "$target")

    # Create target directory if it doesn't exist
    mkdir -p "$target_dir"

    # Backup existing file/directory
    if [ -e "$target" ] && [ ! -L "$target" ]; then
        print_warning "Backing up existing $target"
        mv "$target" "$target.backup"
    fi

    # Remove existing symlink
    if [ -L "$target" ]; then
        rm "$target"
    fi

    # Create new symlink
    ln -s "$source" "$target"
    print_status "Linked $source -> $target"
}

print_status "Linking configuration files..."

# Shell configurations
link_config "$DOTFILES_DIR/config/shell/.zshrc" "$HOME/.zshrc"

# Git configurations
link_config "$DOTFILES_DIR/config/git/.gitconfig" "$HOME/.gitconfig"
link_config "$DOTFILES_DIR/config/git/.gitignore_global" "$HOME/.gitignore_global"

# Tmux configuration
link_config "$DOTFILES_DIR/config/tmux/.tmux.conf" "$HOME/.tmux.conf"
mkdir -p "$HOME/.tmux"
link_config "$DOTFILES_DIR/config/tmux/dev-session" "$HOME/.tmux/dev-session"

# Neovim configuration
link_config "$DOTFILES_DIR/config/nvim" "$HOME/.config/nvim"

# VS Code configurations (if VS Code is installed)
if command -v code &> /dev/null; then
    VSCODE_CONFIG_DIR="$HOME/.config/Code/User"
    mkdir -p "$VSCODE_CONFIG_DIR"
    link_config "$DOTFILES_DIR/config/vscode/settings.json" "$VSCODE_CONFIG_DIR/settings.json"
    link_config "$DOTFILES_DIR/config/vscode/keybindings.json" "$VSCODE_CONFIG_DIR/keybindings.json"
fi

# Create convenience symlinks
mkdir -p "$HOME/bin"
link_config "$DOTFILES_DIR/scripts/utils/battery-status.sh" "$HOME/bin/battery-status"
link_config "$DOTFILES_DIR/scripts/utils/thermal-status.sh" "$HOME/bin/thermal-status"
link_config "$DOTFILES_DIR/scripts/utils/power-mode.sh" "$HOME/bin/power-mode"
link_config "$DOTFILES_DIR/scripts/utils/docker-dev.sh" "$HOME/bin/docker-dev"
link_config "$DOTFILES_DIR/scripts/utils/deploy.sh" "$HOME/bin/deploy"
link_config "$DOTFILES_DIR/scripts/utils/dev-env.sh" "$HOME/bin/dev-env"

# Add ~/bin to PATH if not already there
if ! echo "$PATH" | grep -q "$HOME/bin"; then
    echo 'export PATH="$HOME/bin:$PATH"' >> "$HOME/.zshrc"
fi

print_success "Configuration files linked successfully!"
print_status "Available commands:"
echo "  battery-status  - Check battery status"
echo "  thermal-status  - Monitor temperatures"
echo "  power-mode      - Switch power modes"
echo "  docker-dev      - Docker development utilities"
echo "  deploy          - Deployment utilities"
echo "  dev-env         - Development environment manager"
