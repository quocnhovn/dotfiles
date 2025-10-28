#!/bin/bash

# Enhanced Dotfiles Installation Script for Deepin OS 25
# Optimized for LG Laptop and Fullstack Development
# Enhanced with modern tools and best practices
# Author: Quoc Nho

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
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

# Get the directory where this script is located
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to ensure essential dependencies are installed
ensure_dependencies() {
    local deps=("$@")
    local missing_deps=()

    for dep in "${deps[@]}"; do
        if ! command_exists "$dep"; then
            missing_deps+=("$dep")
        fi
    done

    if [ ${#missing_deps[@]} -gt 0 ]; then
        print_status "Installing missing dependencies: ${missing_deps[*]}"
        sudo apt update
        sudo apt install -y "${missing_deps[@]}"

        # Verify installation
        for dep in "${missing_deps[@]}"; do
            if ! command_exists "$dep"; then
                print_error "Failed to install dependency: $dep"
                exit 1
            fi
        done
        print_success "Dependencies installed successfully"
    fi
}

echo -e "${PURPLE}"
cat << 'EOF'
╔══════════════════════════════════════════════════════╗
║           Enhanced Dotfiles for Deepin OS 25        ║
║                                                      ║
║  🐟 Fish Shell + Starship + Modern CLI Tools        ║
║  🎨 Catppuccin Theme Everywhere                      ║
║  💻 LazyVim + VS Code + Tmux + Yazi                  ║
║  ⚡ System Optimization + Battery Management         ║
║  🚀 Professional Development Environment             ║
╚══════════════════════════════════════════════════════╝
EOF
echo -e "${NC}"

print_status "Dotfiles directory: $DOTFILES_DIR"

# Check if running on Deepin OS
if ! grep -q "deepin" /etc/os-release; then
    print_warning "This script is optimized for Deepin OS. Continuing anyway..."
fi

print_header "System Update"
print_status "Updating system packages..."
sudo apt update && sudo apt upgrade -y

print_header "Essential Packages"
print_status "Installing essential packages..."
sudo apt install -y \
    curl \
    wget \
    git \
    vim \
    neovim \
    tmux \
    htop \
    tree \
    unzip \
    software-properties-common \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    build-essential \
    fish \
    fonts-powerline \
    fonts-firacode

print_header "Development Tools"
print_status "Installing development tools..."
sudo apt install -y \
    docker.io \
    docker-compose \
    nodejs \
    npm \
    python3 \
    python3-pip \
    composer \
    tmux \
    neovim

print_header "Battery Optimization"
print_status "Installing battery optimization tools..."
sudo apt install -y tlp tlp-rdw
sudo systemctl enable tlp

print_header "Modern CLI Tools"
print_status "Installing modern CLI tools..."
bash "$DOTFILES_DIR/scripts/setup/setup-modern-cli.sh"

print_header "Fish Shell Setup"
print_status "Setting up Fish shell..."
bash "$DOTFILES_DIR/scripts/setup/setup-fish.sh"

print_header "VS Code"
if ! command -v code &> /dev/null; then
    print_status "Installing Visual Studio Code..."
    wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
    sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
    sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
    sudo apt update
    sudo apt install -y code
    print_success "VS Code installed successfully"
else
    print_success "VS Code is already installed"
fi

print_header "Docker Engine"
if ! command_exists docker; then
    print_status "Installing Docker Engine..."

    # Ensure required dependencies for Docker installation
    ensure_dependencies "curl" "gnupg" "lsb-release"

    # Uninstall old versions
    sudo apt remove -y docker docker-engine docker.io containerd runc 2>/dev/null || true

    # Update package index and install dependencies
    sudo apt update
    sudo apt install -y \
        ca-certificates \
        curl \
        gnupg \
        lsb-release

    # Add Docker's official GPG key
    sudo mkdir -p /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

    # Add Docker repository (using Ubuntu repo for Deepin compatibility)
    echo \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

    # Install Docker Engine
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

    # Add current user to docker group
    print_status "Adding user to docker group..."
    sudo usermod -aG docker $USER

    # Enable and start Docker service
    sudo systemctl enable docker
    sudo systemctl start docker

    print_success "Docker installed successfully"
    print_warning "Please log out and log back in for docker group changes to take effect"
else
    print_success "Docker is already installed"

    # Check if user is in docker group
    if ! groups $USER | grep -q docker; then
        print_status "Adding user to docker group..."
        sudo usermod -aG docker $USER
        print_warning "Please log out and log back in for docker group changes to take effect"
    else
        print_success "User is already in docker group"
    fi
fi

# Install Docker Compose (standalone) for compatibility
if ! command_exists docker-compose; then
    print_status "Installing Docker Compose standalone..."

    # Ensure curl is available
    ensure_dependencies "curl"

    DOCKER_COMPOSE_VERSION=$(curl -s https://api.github.com/repos/docker/compose/releases/latest | grep 'tag_name' | cut -d\" -f4)
    if [ -n "$DOCKER_COMPOSE_VERSION" ]; then
        sudo curl -L "https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        print_success "Docker Compose standalone installed"
    else
        print_error "Failed to get Docker Compose version"
        exit 1
    fi
fi

# Install Oh My Zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    print_status "Installing Oh My Zsh..."

    # Ensure required dependencies
    ensure_dependencies "curl" "git"

    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    print_success "Oh My Zsh installed successfully"
else
    print_success "Oh My Zsh is already installed"
fi

# Install zsh plugins
print_status "Installing zsh plugins..."

# Ensure git is available for plugin installation
ensure_dependencies "git"

# Install plugins if they don't exist
if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
fi

if [ ! -d "${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
fi

print_success "Zsh plugins installed successfully"

# Install Golang
if ! command_exists go; then
    print_status "Installing Golang..."

    # Ensure required dependencies
    ensure_dependencies "wget" "tar"

    GO_VERSION="1.21.3"
    wget "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz

    # Add Go to PATH
    echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile
    export PATH=$PATH:/usr/local/go/bin

    print_success "Go installed successfully"
else
    print_success "Go is already installed"
fi

print_header "PHP Development"
print_status "Installing PHP and extensions..."
sudo apt install -y \
    php \
    php-cli \
    php-fpm \
    php-json \
    php-common \
    php-mysql \
    php-zip \
    php-gd \
    php-mbstring \
    php-curl \
    php-xml \
    php-pear \
    php-bcmath \
    php-intl

# Install Laravel installer
if ! command_exists laravel; then
    print_status "Installing Laravel installer..."

    # Ensure composer is available
    if ! command_exists composer; then
        print_error "Composer is required for Laravel installer but not found"
        exit 1
    fi

    composer global require laravel/installer
    print_success "Laravel installer installed"
else
    print_success "Laravel installer is already installed"
fi

print_header "Node.js Setup"
# Install Node Version Manager (nvm)
if [ ! -d "$HOME/.nvm" ]; then
    print_status "Installing Node Version Manager (nvm)..."

    # Ensure curl is available
    ensure_dependencies "curl"

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

    # Source nvm to make it available immediately
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    print_success "NVM installed successfully"
else
    print_success "NVM is already installed"
fi

print_header "Configuration Setup"
print_status "Running setup scripts..."
chmod +x "$DOTFILES_DIR/scripts/setup/"*.sh
chmod +x "$DOTFILES_DIR/scripts/utils/"*.sh

# Setup configurations
"$DOTFILES_DIR/scripts/setup/link-configs.sh"

print_header "Development Environment"
"$DOTFILES_DIR/scripts/setup/setup-runtime.sh"
"$DOTFILES_DIR/scripts/setup/setup-git.sh"

print_header "LazyVim IDE Setup"
print_status "Setting up LazyVim IDE with fullstack development support..."
print_status "• PHP (Laravel/Symfony/CodeIgniter) development"
print_status "• Go development with full toolchain"
print_status "• Vue.js/TypeScript frontend development"
print_status "• Python development support"
print_status "• Database integration and debugging tools"
"$DOTFILES_DIR/scripts/setup/setup-bob.sh"

print_header "Tmux Setup"
print_status "Setting up Tmux with plugins..."
"$DOTFILES_DIR/scripts/setup/setup-tmux.sh"

print_header "Yazi File Manager"
print_status "Setting up Yazi with plugins..."
"$DOTFILES_DIR/scripts/setup/setup-yazi.sh"

print_header "VS Code Setup"
"$DOTFILES_DIR/scripts/setup/setup-vscode.sh"

print_header "System Optimization"
print_status "Setting up system optimization tools..."
"$DOTFILES_DIR/scripts/setup/setup-system-optimization.sh"

print_header "Battery Optimization"
"$DOTFILES_DIR/scripts/setup/setup-battery.sh"

# Optional: Setup YADM for advanced dotfiles management
echo
read -p "Do you want to setup YADM for professional dotfiles management? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    "$DOTFILES_DIR/scripts/utils/yadm-manager.sh" init
fi

# Optional: Backup Deepin Browser data
echo
read -p "Do you want to backup current Deepin Browser data (bookmarks, extensions)? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_header "Deepin Browser Backup"
    "$DOTFILES_DIR/scripts/setup/setup-browser-backup.sh" backup
fi

# Change default shell to Fish
if [ "$SHELL" != "/usr/bin/fish" ] && [ "$SHELL" != "/bin/fish" ]; then
    print_status "Changing default shell to Fish..."
    chsh -s $(which fish)
    print_warning "Please log out and log back in for shell change to take effect"
fi

# Setup Fish plugins
print_status "Setting up Fish plugins..."
fish -c "~/.config/fish/functions/setup-fish-plugins.fish"

# Disable UOS AI if exists
print_status "Disabling UOS AI services..."
sudo systemctl disable uos-ai-assistant 2>/dev/null || true
sudo systemctl stop uos-ai-assistant 2>/dev/null || true

print_header "Final Cleanup"
print_status "Cleaning up..."
sudo apt autoremove -y
sudo apt autoclean

print_success "🎉 Enhanced Dotfiles installation completed!"

echo -e "${PURPLE}"
cat << 'EOF'

╔══════════════════════════════════════════════════════╗
║                 Installation Complete               ║
║                                                      ║
║  ✅ Fish shell with modern CLI tools                ║
║  ✅ LazyVim IDE with fullstack development          ║
║  ✅ PHP/Laravel/Go/Vue.js development ready          ║
║  ✅ VS Code with enhanced extensions                 ║
║  ✅ Docker Engine with user permissions             ║
║  ✅ Tmux with plugins and themes                     ║
║  ✅ Yazi file manager with plugins                   ║
║  ✅ System optimization tools                        ║
║  ✅ Battery optimization for laptop                  ║
║  ✅ Database tools and debugging support             ║
║  ✅ Catppuccin theme everywhere                      ║
║  ✅ Deepin Browser backup (optional)                 ║
╚══════════════════════════════════════════════════════╝

EOF
echo -e "${NC}"

echo -e "${GREEN}🔧 Browser Management Commands:${NC}"
echo "  • Backup browser: ./scripts/setup/setup-browser-backup.sh backup"
echo "  • Restore browser: ./scripts/setup/setup-browser-restore.sh"
echo "  • List extensions: ./scripts/setup/setup-browser-backup.sh list"
echo ""

echo -e "${BLUE}🐳 Docker Commands:${NC}"
echo "  • Check status: docker --version && docker-compose --version"
echo "  • Test installation: docker run hello-world"
echo "  • Manage containers: docker ps, docker images"
echo "  • Docker Compose: docker-compose up -d, docker-compose down"
echo ""

echo -e "${YELLOW}🚀 LazyVim IDE Setup:${NC}"
echo "  • Run: /tmp/nvim-first-setup.sh (complete plugin installation)"
echo "  • Use: nvim (start coding immediately)"
echo "  • Check: :checkhealth (verify installation)"
echo "  • Manage: :Mason (language servers)"
echo ""

print_warning "Please reboot your system to ensure all changes take effect."
print_warning "After reboot, test Docker with: docker run hello-world"

echo ""
print_header "Next Steps"
echo "1. 🔄 Reboot your system (required for Docker group permissions)"
echo "2. 🐟 Fish shell will be your new default"
echo "3. 🐳 Test Docker installation: docker run hello-world"
echo "4. 💻 Run LazyVim first setup: /tmp/nvim-first-setup.sh"
echo "5. 💻 Start coding with: nvim"
echo "6. 🔧 Configure Git credentials:"
echo "   git config --global user.name 'Your Name'"
echo "   git config --global user.email 'your.email@example.com'"
echo "6. 🔋 Battery optimization is active with TLP and auto-cpufreq"
echo "7. 📁 Use 'yazi' for file management, 'nvim' for editing"
echo "8. ⚡ Use 'update-all' for system updates with topgrade"
echo ""

print_header "LazyVim IDE Features"
echo "• <leader>? - Show all keybindings"
echo "• <leader>ps - Switch projects"
echo "• <leader>tt - Toggle terminal"
echo "• <leader>db - Database UI"
echo "• <F5> - Start debugging"
echo "• <leader>la - Laravel artisan (PHP projects)"
echo "• <leader>gt - Go tests"
echo ""

print_header "Quick Commands"
echo "• sysinfo       - System information"
echo "• battery       - Battery status"
echo "• dev-env       - Setup project environment"
echo "• yazi or fm    - File manager"
echo "• update-all    - Update everything"
echo "• system-maintenance - Full system maintenance"
echo "• docker ps     - List running containers"
echo "• dc up -d      - Start docker-compose services"
echo "• dc down       - Stop docker-compose services"
