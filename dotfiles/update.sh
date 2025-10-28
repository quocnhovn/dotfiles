#!/bin/bash

# Dotfiles Update Script for Deepin OS 25
# Updates all previously installed applications and tools
# Author: Quoc Nho

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[UPDATE]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${PURPLE}=== $1 ===${NC}"
}

print_info() {
    echo -e "${CYAN}[INFO]${NC} $1"
}

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Helper function to safely install/update cargo packages
install_cargo_package() {
    local package=$1
    if command -v cargo >/dev/null 2>&1; then
        print_status "Installing/updating $package via cargo..."
        cargo install "$package" 2>/dev/null || print_warning "Failed to install $package"
    else
        print_warning "Cargo not available, cannot install $package"
    fi
}

# Helper function to check if a cargo package is installed
is_cargo_package_installed() {
    local package=$1
    if command -v cargo >/dev/null 2>&1; then
        cargo install --list | grep -q "^$package "
    else
        return 1
    fi
}

# Backup function
create_backup() {
    local backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    print_status "Creating backup at: $backup_dir"
    mkdir -p "$backup_dir"

    # Backup important configs
    [ -f "$HOME/.config/nvim/lazy-lock.json" ] && cp "$HOME/.config/nvim/lazy-lock.json" "$backup_dir/"
    [ -f "$HOME/.config/fish/config.fish" ] && cp "$HOME/.config/fish/config.fish" "$backup_dir/"
    [ -f "$HOME/.gitconfig" ] && cp "$HOME/.gitconfig" "$backup_dir/"

    print_success "Backup created at: $backup_dir"
}

echo -e "${PURPLE}"
cat << 'EOF'
╔══════════════════════════════════════════════════════╗
║              Dotfiles Update Script                 ║
║                                                      ║
║  🔄 Update all installed applications               ║
║  📦 Update package managers and tools               ║
║  🛠️ Update development environments                  ║
║  🔧 Refresh configurations                          ║
╚══════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

print_info "Starting comprehensive update process..."

# Create backup before updating
create_backup

print_header "System Packages Update"
print_status "Updating system packages..."
sudo apt update
sudo apt upgrade -y
sudo apt autoremove -y
sudo apt autoclean
print_success "System packages updated"

print_header "Snap Packages Update"
if command -v snap >/dev/null 2>&1; then
    print_status "Updating snap packages..."
    sudo snap refresh
    print_success "Snap packages updated"
else
    print_warning "Snap not available"
fi

print_header "Flatpak Packages Update"
if command -v flatpak >/dev/null 2>&1; then
    print_status "Updating Flatpak packages..."
    flatpak update -y
    print_success "Flatpak packages updated"
else
    print_warning "Flatpak not available"
fi

print_header "Docker Update"
if command -v docker >/dev/null 2>&1; then
    print_status "Updating Docker images..."
    docker system prune -f
    print_status "Pulling latest base images..."
    docker pull ubuntu:latest 2>/dev/null || true
    docker pull alpine:latest 2>/dev/null || true
    docker pull node:latest 2>/dev/null || true
    docker pull php:latest 2>/dev/null || true
    print_success "Docker updated and cleaned"
else
    print_warning "Docker not installed"
fi

print_header "Node.js and NPM Update"
if command -v nvm >/dev/null 2>&1; then
    print_status "Updating Node.js via NVM..."
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Update NVM itself
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

    # Install latest LTS Node.js
    nvm install --lts
    nvm use --lts
    nvm alias default node

    # Update global npm packages
    npm update -g
    print_success "Node.js and NPM updated"
elif command -v npm >/dev/null 2>&1; then
    print_status "Updating global NPM packages..."
    npm update -g
    print_success "NPM packages updated"
else
    print_warning "Node.js/NPM not installed"
fi

print_header "Python and Pip Update"
if command -v pip3 >/dev/null 2>&1; then
    print_status "Updating Python packages..."
    pip3 install --upgrade pip
    pip3 list --outdated --format=freeze | grep -v '^\-e' | cut -d = -f 1 | xargs -n1 pip3 install -U 2>/dev/null || true
    print_success "Python packages updated"
else
    print_warning "Python3/pip3 not installed"
fi

print_header "Composer Update"
if command -v composer >/dev/null 2>&1; then
    print_status "Updating Composer..."
    composer self-update

    # Update global packages
    if [ -d "$HOME/.config/composer" ]; then
        cd "$HOME/.config/composer"
        composer global update
        cd - >/dev/null
    fi
    print_success "Composer updated"
else
    print_warning "Composer not installed"
fi

print_header "Go Update"
if command -v go >/dev/null 2>&1; then
    print_status "Updating Go..."
    GO_VERSION=$(curl -s https://api.github.com/repos/golang/go/releases/latest | grep -oP '"tag_name": "\K(.*)(?=")')

    if [ ! -z "$GO_VERSION" ]; then
        print_status "Latest Go version: $GO_VERSION"
        CURRENT_VERSION=$(go version | awk '{print $3}')

        if [ "$CURRENT_VERSION" != "$GO_VERSION" ]; then
            print_status "Updating Go from $CURRENT_VERSION to $GO_VERSION..."
            wget "https://go.dev/dl/${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
            sudo rm -rf /usr/local/go
            sudo tar -C /usr/local -xzf /tmp/go.tar.gz
            rm /tmp/go.tar.gz
            print_success "Go updated to $GO_VERSION"
        else
            print_success "Go is already up to date"
        fi
    fi

    # Update Go tools
    print_status "Updating Go tools..."
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    print_success "Go tools updated"
else
    print_warning "Go not installed"
fi

print_header "Rust and Cargo Update"
if command -v rustup >/dev/null 2>&1; then
    print_status "Updating Rust toolchain..."
    rustup update

    # Check if cargo-update is installed before using it
    if is_cargo_package_installed "cargo-update"; then
        cargo install-update -a 2>/dev/null || true
    else
        print_status "Installing cargo-update for future use..."
        install_cargo_package "cargo-update"
        cargo install-update -a 2>/dev/null || true
    fi

    print_success "Rust updated"
elif command -v cargo >/dev/null 2>&1; then
    print_warning "Rust installed but rustup not found"
    print_info "Consider installing rustup for better Rust management"
else
    print_warning "Rust not installed"
    read -p "Would you like to install Rust? (y/N): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        print_status "Installing Rust via rustup..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
        print_success "Rust installed successfully"
    fi
fi

print_header "Modern CLI Tools Update"
print_status "Updating modern CLI tools..."

# Update exa/eza via cargo only if cargo is available
if command -v cargo >/dev/null 2>&1; then
    print_status "Updating Rust-based CLI tools via cargo..."
    install_cargo_package "eza"
    install_cargo_package "bat"
    install_cargo_package "fd-find"
    install_cargo_package "ripgrep"
    install_cargo_package "zoxide"
else
    print_warning "Cargo not available, skipping Rust-based tool updates"
fi

# Update via package manager
sudo apt update
sudo apt install -y --only-upgrade \
    exa \
    bat \
    fd-find \
    ripgrep \
    fzf \
    tree \
    jq \
    httpie \
    neofetch 2>/dev/null || true

print_success "Modern CLI tools updated"

print_header "Starship Prompt Update"
if command -v starship >/dev/null 2>&1; then
    print_status "Updating Starship prompt..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
    print_success "Starship updated"
else
    print_warning "Starship not installed"
fi

print_header "Neovim and Plugins Update"
if command -v nvim >/dev/null 2>&1; then
    print_status "Updating Neovim via Bob..."
    if command -v bob >/dev/null 2>&1; then
        bob sync
        bob use stable
        print_success "Neovim updated via Bob"
    else
        print_warning "Bob not installed, skipping Neovim update"
    fi

    print_status "Updating Neovim plugins..."
    # Update LazyVim plugins
    nvim --headless "+Lazy! sync" +qa 2>/dev/null || true

    # Update Mason packages
    nvim --headless "+MasonUpdate" +qa 2>/dev/null || true

    print_success "Neovim plugins updated"
else
    print_warning "Neovim not installed"
fi

print_header "VS Code Extensions Update"
if command -v code >/dev/null 2>&1; then
    print_status "Updating VS Code extensions..."
    code --update-extensions 2>/dev/null || true
    print_success "VS Code extensions updated"
else
    print_warning "VS Code not installed"
fi

print_header "Fish Shell and Plugins Update"
if command -v fish >/dev/null 2>&1; then
    print_status "Updating Fish shell plugins..."

    # Update Fisher (check if installed first)
    if fish -c "functions -q fisher" 2>/dev/null; then
        print_status "Updating Fisher plugins..."
        fish -c "fisher update" 2>/dev/null || true
    else
        print_warning "Fisher not installed in Fish shell"
    fi

    # Update Oh My Fish (check if installed first)
    if [ -d "$HOME/.local/share/omf" ]; then
        print_status "Updating Oh My Fish..."
        fish -c "omf update" 2>/dev/null || true
    else
        print_warning "Oh My Fish not installed"
    fi

    print_success "Fish shell plugins updated"
else
    print_warning "Fish shell not installed"
fi

print_header "Tmux Plugins Update"
if command -v tmux >/dev/null 2>&1; then
    print_status "Updating Tmux plugins..."

    # Update TPM (Tmux Plugin Manager)
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        cd "$HOME/.tmux/plugins/tpm"
        git pull
        cd - >/dev/null

        # Update all plugins
        "$HOME/.tmux/plugins/tpm/bin/update_plugins" all 2>/dev/null || true
    fi

    print_success "Tmux plugins updated"
else
    print_warning "Tmux not installed"
fi

print_header "Yazi File Manager Update"
if command -v yazi >/dev/null 2>&1; then
    if command -v cargo >/dev/null 2>&1; then
        print_status "Updating Yazi via cargo..."
        cargo install --git https://github.com/sxyazi/yazi.git 2>/dev/null || true
        print_success "Yazi updated"
    else
        print_warning "Cargo not available, cannot update Yazi from source"
        print_info "Consider updating Yazi through your package manager"
    fi
else
    print_warning "Yazi not installed"
fi

print_header "Git Configuration Refresh"
print_status "Refreshing Git configuration..."
if [ -f "$DOTFILES_DIR/config/git/.gitconfig" ]; then
    cp "$DOTFILES_DIR/config/git/.gitconfig" "$HOME/.gitconfig"
    print_success "Git configuration refreshed"
fi

print_header "Topgrade Universal Updater"
if command -v topgrade >/dev/null 2>&1; then
    print_status "Running Topgrade for comprehensive updates..."
    topgrade --yes 2>/dev/null || true
    print_success "Topgrade completed"
else
    print_status "Installing Topgrade..."
    if command -v cargo >/dev/null 2>&1; then
        print_status "Installing Topgrade via cargo..."
        cargo install topgrade 2>/dev/null || true
        if command -v topgrade >/dev/null 2>&1; then
            print_status "Running Topgrade for the first time..."
            topgrade --yes 2>/dev/null || true
            print_success "Topgrade installed and executed"
        else
            print_error "Failed to install Topgrade via cargo"
        fi
    else
        print_warning "Cargo not available, cannot install Topgrade"
        print_info "Install Rust/Cargo first to use Topgrade"
    fi
fi

print_header "Cleanup and Optimization"
print_status "Performing system cleanup..."

# Clear package caches
sudo apt autoremove -y
sudo apt autoclean

# Clear npm cache
if command -v npm >/dev/null 2>&1; then
    npm cache clean --force 2>/dev/null || true
fi

# Clear pip cache
if command -v pip3 >/dev/null 2>&1; then
    pip3 cache purge 2>/dev/null || true
fi

# Clear cargo cache (check if cargo-cache is available)
if command -v cargo >/dev/null 2>&1; then
    if is_cargo_package_installed "cargo-cache"; then
        print_status "Cleaning cargo cache..."
        cargo cache --autoclean 2>/dev/null || true
    else
        print_status "Installing cargo-cache for future use..."
        install_cargo_package "cargo-cache"
        cargo cache --autoclean 2>/dev/null || true
    fi
fi

# Clear Docker cache
if command -v docker >/dev/null 2>&1; then
    docker system prune -f 2>/dev/null || true
fi

print_success "System cleanup completed"

print_header "Configuration Refresh"
print_status "Refreshing dotfiles configurations..."

# Re-run the link configs script
if [ -f "$DOTFILES_DIR/scripts/setup/link-configs.sh" ]; then
    bash "$DOTFILES_DIR/scripts/setup/link-configs.sh"
    print_success "Configurations refreshed"
fi

print_header "Final System Update"
print_status "Performing final system update..."
sudo apt update
sudo apt upgrade -y
print_success "Final system update completed"

print_success "🎉 All applications and tools have been updated!"

echo -e "${PURPLE}"
cat << 'EOF'

╔══════════════════════════════════════════════════════╗
║                Update Complete!                     ║
║                                                      ║
║  ✅ System packages updated                         ║
║  ✅ Development tools updated                       ║
║  ✅ Programming languages updated                   ║
║  ✅ CLI tools updated                               ║
║  ✅ Editor plugins updated                          ║
║  ✅ Shell configurations refreshed                  ║
║  ✅ System optimized and cleaned                    ║
╚══════════════════════════════════════════════════════╝

EOF
echo -e "${NC}"

echo -e "${GREEN}📊 Update Summary:${NC}"
echo "  • System packages: Updated to latest versions"
echo "  • Development tools: Refreshed and optimized"
echo "  • Package managers: Updated and cleaned"
echo "  • Editor plugins: Synchronized with latest versions"
echo "  • Configurations: Refreshed from dotfiles"
echo ""

echo -e "${YELLOW}🔄 Recommended Next Steps:${NC}"
echo "  1. Restart your terminal or run: source ~/.bashrc"
echo "  2. Test critical applications: nvim, code, docker"
echo "  3. Check for any broken configurations"
echo "  4. Consider rebooting if system packages were updated"
echo ""

echo -e "${BLUE}💡 Maintenance Tips:${NC}"
echo "  • Run this script monthly for optimal performance"
echo "  • Use 'topgrade' command for quick daily updates"
echo "  • Monitor disk space after updates"
echo "  • Backup important work before major updates"
echo ""

print_info "Update completed successfully at $(date)"
print_info "Backup location: Check ~/.dotfiles-backup-* directories"
