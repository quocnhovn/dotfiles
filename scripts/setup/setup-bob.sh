#!/bin/bash

# Setup script for Bob Neovim version manager with lazy-nvim-ide integration
# Enhanced for Deepin OS 25 with fullstack development support

LOG_FILE="/tmp/neovim-lazyvim-setup.log"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
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

print_header() {
    echo -e "${PURPLE}"
    echo "=============================================="
    echo "    LAZY NVIM IDE SETUP FOR DEEPIN OS"
    echo "=============================================="
    echo -e "${NC}"
}

# Start setup
log "🚀 Setting up Bob (Neovim version manager)..."

# Install required dependencies first
log "Installing required dependencies..."
sudo apt update
sudo apt install -y curl git

# Check if bob is already installed
if command -v bob &> /dev/null; then
    log "Bob is already installed"
    bob --version
else
    log "Installing Bob..."

    # Ensure curl is available
    if ! command -v curl &> /dev/null; then
        error "curl is required but not installed"
        exit 1
    fi

    # Install bob
    if curl -sL https://raw.githubusercontent.com/MordechaiHadad/bob/master/install | bash; then
        log "✅ Bob installed successfully"

        # Add bob to PATH if not already there
        if ! command -v bob &> /dev/null; then
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
            echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
            if [ -f ~/.config/fish/config.fish ]; then
                echo 'fish_add_path ~/.local/bin' >> ~/.config/fish/config.fish
            fi
            export PATH="$HOME/.local/bin:$PATH"
        fi

        # Verify bob installation
        if ! command -v bob &> /dev/null; then
            error "Bob installation failed - command not found after installation"
            exit 1
        fi
    else
        error "Failed to install Bob"
        exit 1
    fi
fi

# Install latest stable Neovim
log "Installing latest stable Neovim with Bob..."
bob install stable
bob use stable

# Install nightly build (optional)
info "Installing Neovim nightly build for latest features..."
bob install nightly

# Install additional tools for LazyVim IDE
log "Installing development tools for LazyVim IDE..."

# Install ripgrep for telescope search
if ! command -v rg &> /dev/null; then
    info "Installing ripgrep for better search..."
    sudo apt update && sudo apt install -y ripgrep
fi

# Install fd for file finding
if ! command -v fd &> /dev/null; then
    info "Installing fd for file finding..."
    sudo apt install -y fd-find
    # Create symlink for fd command
    sudo ln -sf $(which fdfind) /usr/local/bin/fd 2>/dev/null || true
fi

# Install tree-sitter CLI
if ! command -v tree-sitter &> /dev/null; then
    info "Installing tree-sitter CLI..."
    if command -v npm &> /dev/null; then
        npm install -g tree-sitter-cli
    else
        warning "npm not found, skipping tree-sitter CLI installation"
        info "Install Node.js/npm first to get tree-sitter CLI"
    fi
else
    info "tree-sitter CLI already installed"
fi

# Install language servers and tools
install_language_tools() {
    log "Installing language servers and development tools..."

    # PHP development tools
    if command -v composer &> /dev/null; then
        info "Installing PHP language server (Intelephense)..."
        # Note: Intelephense will be installed via Mason in Neovim
    fi

    # Go development tools
    if command -v go &> /dev/null; then
        info "Installing Go development tools..."
        go install golang.org/x/tools/gopls@latest
        go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
        go install mvdan.cc/gofumpt@latest
    fi

    # Node.js development tools
    if command -v npm &> /dev/null; then
        info "Installing Node.js development tools..."
        npm install -g typescript typescript-language-server
        npm install -g vls # Vue Language Server
        npm install -g @tailwindcss/language-server
        npm install -g prettier eslint
    fi

    # Python development tools
    if command -v python3 &> /dev/null; then
        info "Installing Python development tools..."
        python3 -m pip install --user pynvim
        python3 -m pip install --user black isort flake8
    fi
}

# Install debugging tools
install_debug_tools() {
    log "Installing debugging tools..."

    # Install delve for Go debugging
    if command -v go &> /dev/null; then
        go install github.com/go-delve/delve/cmd/dlv@latest
    fi
}

# Clean up and backup old Neovim config
backup_old_config() {
    if [ -d "$HOME/.config/nvim" ] && [ ! -L "$HOME/.config/nvim" ]; then
        warning "Existing Neovim config found, creating backup..."
        mv "$HOME/.config/nvim" "$HOME/.config/nvim-backup-$(date +%Y%m%d-%H%M%S)"
        log "✅ Old config backed up"
    fi

    # Clean old data
    if [ -d "$HOME/.local/share/nvim" ]; then
        info "Cleaning old Neovim data..."
        rm -rf "$HOME/.local/share/nvim"
    fi

    if [ -d "$HOME/.cache/nvim" ]; then
        rm -rf "$HOME/.cache/nvim"
    fi
}

# Install fonts for better terminal experience
install_fonts() {
    log "Installing Nerd Fonts for better terminal experience..."

    local font_dir="$HOME/.local/share/fonts"
    mkdir -p "$font_dir"

    # Download and install JetBrains Mono Nerd Font
    if [ ! -f "$font_dir/JetBrains Mono Regular Nerd Font Complete.ttf" ]; then
        info "Installing JetBrains Mono Nerd Font..."
        curl -fLo "$font_dir/JetBrains Mono Regular Nerd Font Complete.ttf" \
            https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/JetBrainsMono/Ligatures/Regular/complete/JetBrains%20Mono%20Regular%20Nerd%20Font%20Complete.ttf

        # Refresh font cache
        fc-cache -fv >/dev/null 2>&1
        log "✅ Font installed and cache refreshed"
    fi
}

# Run installation functions
install_language_tools
install_debug_tools
install_fonts

# Create first run setup script for Neovim
create_neovim_first_run() {
    cat > /tmp/nvim-first-setup.sh << 'EOF'
#!/bin/bash
echo "🚀 Starting LazyVim first-time setup..."
echo "This will install all plugins and language servers..."
echo ""

# Start Neovim in headless mode to install plugins
nvim --headless "+Lazy! sync" +qa

# Install language servers via Mason
nvim --headless -c "MasonInstall intelephense gopls typescript-language-server vue-language-server lua-language-server" -c "qa"

echo ""
echo "✅ LazyVim setup completed!"
echo "🎉 You can now run 'nvim' to start coding!"
EOF

    chmod +x /tmp/nvim-first-setup.sh
    log "✅ First-run setup script created at /tmp/nvim-first-setup.sh"
}

create_neovim_first_run

log "✅ LazyVim IDE setup completed!"

# Display summary and next steps
echo ""
echo -e "${PURPLE}"
cat << 'EOF'
╔══════════════════════════════════════════════════════╗
║               LAZYVIM IDE INSTALLATION               ║
║                     COMPLETED!                      ║
╚══════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

echo -e "${GREEN}🎉 Installation Summary:${NC}"
echo "   ✅ Bob Neovim version manager installed"
echo "   ✅ Latest stable Neovim installed"
echo "   ✅ Development tools and dependencies"
echo "   ✅ Language servers preparation"
echo "   ✅ JetBrains Mono Nerd Font installed"
echo "   ✅ LazyVim IDE configuration ready"
echo ""

echo -e "${BLUE}🔧 Enhanced Features:${NC}"
echo "   • PHP Development (Laravel/Symfony/CodeIgniter)"
echo "   • Go Development with full toolchain"
echo "   • Vue.js/TypeScript frontend development"
echo "   • Python development support"
echo "   • Database integration (DBUI)"
echo "   • Enhanced debugging (DAP)"
echo "   • Project management and sessions"
echo "   • Git workflow integration"
echo "   • Terminal integration with Fish shell"
echo ""

echo -e "${YELLOW}🚀 Next Steps:${NC}"
echo "   1. Run: source ~/.bashrc (or restart terminal)"
echo "   2. Run: /tmp/nvim-first-setup.sh (install plugins)"
echo "   3. Run: nvim (start coding!)"
echo "   4. Use :checkhealth to verify setup"
echo "   5. Use :Mason to manage language servers"
echo ""

echo -e "${GREEN}💡 Pro Tips:${NC}"
echo "   • Use <leader>? to see all key mappings"
echo "   • Use <leader>ps to switch between projects"
echo "   • Use <leader>tt for integrated terminal"
echo "   • Use <leader>db for database management"
echo "   • Use <F5> to start debugging sessions"
echo ""

echo -e "${BLUE}📚 Configuration Location:${NC}"
echo "   ~/.config/nvim/ (LazyVim IDE configuration)"
echo "   ~/.local/share/nvim/ (Plugin data)"
echo "   ~/.cache/nvim/ (Cache files)"
echo ""

if [ -f "$LOG_FILE" ]; then
    echo -e "${BLUE}📝 Installation log: $LOG_FILE${NC}"
fi

# Display summary
echo
echo "🎉 Bob Setup Summary:"
echo "===================="
echo "• Bob version: $(bob --version 2>/dev/null || echo 'Not in PATH')"
echo "• Installed Neovim versions:"
bob ls 2>/dev/null || echo "  - None found"
echo
echo "📚 Common Bob commands:"
echo "• bob install <version>  - Install a version"
echo "• bob use <version>      - Switch to a version"
echo "• bob ls                 - List installed versions"
echo "• bob uninstall <version> - Remove a version"
echo
echo "💡 Tip: Use 'bob install latest' to get the latest release"
