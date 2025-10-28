#!/bin/bash

# System optimization tools setup for Deepin OS 25
# Based on best practices from dotfiles-docs.vercel.app

LOG_FILE="/tmp/system-optimization-setup.log"

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
log "⚡ Setting up system optimization tools for Deepin OS 25..."

# 1. Install auto-cpufreq for automatic CPU frequency management
log "Installing auto-cpufreq..."
if ! command -v auto-cpufreq &> /dev/null; then
    # Clone and install auto-cpufreq
    cd /tmp
    git clone https://github.com/AdnanHodzic/auto-cpufreq.git
    cd auto-cpufreq
    sudo ./auto-cpufreq-installer --install

    # Enable the service
    sudo systemctl enable auto-cpufreq.service
    sudo systemctl start auto-cpufreq.service

    log "✅ auto-cpufreq installed and enabled"
else
    log "auto-cpufreq already installed"
fi

# 2. Install topgrade for unified package management
log "Installing topgrade..."
if ! command -v topgrade &> /dev/null; then
    # Install topgrade from GitHub releases
    TOPGRADE_VERSION=$(curl -s https://api.github.com/repos/topgrade-rs/topgrade/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
    if [ -n "$TOPGRADE_VERSION" ]; then
        wget -O /tmp/topgrade.deb "https://github.com/topgrade-rs/topgrade/releases/download/${TOPGRADE_VERSION}/topgrade-${TOPGRADE_VERSION#v}-x86_64-unknown-linux-gnu.deb"
        sudo dpkg -i /tmp/topgrade.deb || sudo apt --fix-broken install -y
        log "✅ topgrade installed"
    else
        warning "Could not install topgrade from releases, trying cargo..."
        if command -v cargo &> /dev/null; then
            cargo install topgrade
            log "✅ topgrade installed via cargo"
        else
            error "Could not install topgrade"
        fi
    fi
else
    log "topgrade already installed"
fi

# 3. Install vivid for better LS_COLORS (if not already installed)
log "Installing vivid..."
if ! command -v vivid &> /dev/null; then
    # Try apt first
    if sudo apt install -y vivid 2>/dev/null; then
        log "✅ vivid installed from apt"
    else
        # Install from GitHub releases
        VIVID_VERSION=$(curl -s https://api.github.com/repos/sharkdp/vivid/releases/latest | grep '"tag_name":' | cut -d'"' -f4)
        if [ -n "$VIVID_VERSION" ]; then
            wget -O /tmp/vivid.deb "https://github.com/sharkdp/vivid/releases/download/${VIVID_VERSION}/vivid_${VIVID_VERSION#v}_amd64.deb"
            sudo dpkg -i /tmp/vivid.deb || sudo apt --fix-broken install -y
            log "✅ vivid installed from GitHub"
        else
            warning "Could not install vivid"
        fi
    fi
else
    log "vivid already installed"
fi

# 4. Install additional system monitoring tools
log "Installing system monitoring tools..."

# Install htop, neofetch, and other useful tools
sudo apt update
sudo apt install -y \
    htop \
    neofetch \
    tree \
    curl \
    wget \
    git \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release

# 5. Setup TLP if not already configured
log "Configuring TLP for battery optimization..."
if ! systemctl is-enabled tlp.service &> /dev/null; then
    sudo apt install -y tlp tlp-rdw
    sudo systemctl enable tlp.service
    sudo systemctl start tlp.service
    log "✅ TLP enabled and started"
else
    log "TLP already configured"
fi

# 6. Install laptop-specific tools
log "Installing laptop-specific tools..."
sudo apt install -y \
    powertop \
    acpi \
    lm-sensors \
    fancontrol

# Configure sensors
sudo sensors-detect --auto

# 7. Create topgrade configuration
log "Creating topgrade configuration..."
mkdir -p ~/.config/topgrade
cat > ~/.config/topgrade/topgrade.toml << 'EOF'
# Topgrade configuration for Deepin OS 25

[misc]
# Disable specific steps
disable = ["system", "firmware"]

# Only run if the user is not root
assume_yes = false
cleanup = true

[linux]
# Arch pacman
arch_package_manager = "apt"

# Flatpak
flatpak = true

# Snap packages
snap = true

[npm]
# Use npm
use_npm = true

# Use yarn
use_yarn = true

[composer]
self_update = true

[firmware]
# Skip firmware updates
upgrade_firmware = false

[python]
# Update pip packages
upgrade_pip = true

# Update pipx packages
pipx_inject = true

[cargo]
# Update cargo packages
update_cargo = true

[git]
# Pull git repositories
max_concurrency = 5
repos = [
    "~/Development/",
    "~/.config/",
]

[commands]
# Custom commands to run
"Update Fish plugins" = "fish -c 'fisher update'"
"Clean Docker" = "docker system prune -f"
"Update Neovim plugins" = "nvim --headless +Lazy! update +qa"
EOF

log "✅ Topgrade configuration created"

# 8. Create system optimization aliases for Fish shell
log "Adding system optimization aliases to Fish..."
if [ -d ~/.config/fish ]; then
    cat >> ~/.config/fish/config.fish << 'EOF'

# System optimization aliases
alias sysinfo='neofetch'
alias sysmon='htop'
alias battery='acpi -b'
alias temp='sensors'
alias cpufreq='watch -n 1 "cat /proc/cpuinfo | grep MHz"'
alias update-all='topgrade'
alias clean-system='sudo apt autoremove && sudo apt autoclean && docker system prune -f'
alias optimize='sudo auto-cpufreq --stats'
EOF
    log "✅ System aliases added to Fish config"
fi

# 9. Setup a system maintenance script
log "Creating system maintenance script..."
cat > ~/.local/bin/system-maintenance << 'EOF'
#!/bin/bash

# System maintenance script for Deepin OS 25

echo "🔧 Running system maintenance..."

# Update packages with topgrade
echo "📦 Updating packages..."
topgrade --yes

# Clean package cache
echo "🧹 Cleaning package cache..."
sudo apt autoremove -y
sudo apt autoclean

# Clean Docker if installed
if command -v docker &> /dev/null; then
    echo "🐳 Cleaning Docker..."
    docker system prune -f
fi

# Update locate database
echo "📍 Updating locate database..."
sudo updatedb

# Show system info
echo "💻 System information:"
neofetch --off

# Show battery status if laptop
if [ -d /sys/class/power_supply/BAT* ]; then
    echo "🔋 Battery status:"
    acpi -b
fi

# Show CPU frequency
echo "⚡ CPU frequency:"
auto-cpufreq --stats | head -20

echo "✅ System maintenance completed!"
EOF

chmod +x ~/.local/bin/system-maintenance
log "✅ System maintenance script created"

log "✅ System optimization setup completed!"

# Display summary
echo
echo "🎉 System Optimization Setup Summary:"
echo "===================================="
echo "• auto-cpufreq: $(auto-cpufreq --version 2>/dev/null | head -1 || echo 'Not installed')"
echo "• topgrade: $(topgrade --version 2>/dev/null || echo 'Not installed')"
echo "• vivid: $(vivid --version 2>/dev/null || echo 'Not installed')"
echo "• TLP status: $(systemctl is-active tlp.service 2>/dev/null || echo 'Not running')"
echo
echo "🔧 Available commands:"
echo "  • update-all      - Update everything with topgrade"
echo "  • system-maintenance - Run full system maintenance"
echo "  • sysinfo         - Show system information"
echo "  • sysmon          - System monitor (htop)"
echo "  • battery         - Battery status"
echo "  • temp            - CPU temperatures"
echo "  • optimize        - CPU frequency stats"
echo "  • clean-system    - Clean system cache and Docker"
echo
echo "📅 Recommendation:"
echo "  • Run 'update-all' weekly"
echo "  • Run 'system-maintenance' monthly"
echo "  • Monitor battery with 'battery' command"
echo "  • Check CPU optimization with 'optimize' command"
echo
echo "⚡ auto-cpufreq is now managing CPU frequency automatically"
echo "🔋 TLP is optimizing battery usage"
