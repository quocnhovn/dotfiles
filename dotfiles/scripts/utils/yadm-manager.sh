#!/bin/bash

# YADM Dotfiles Management Setup
# Integrate YADM for better dotfiles management

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[YADM]${NC} $1"
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

show_help() {
    echo "YADM Dotfiles Management"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  init     - Initialize YADM repository"
    echo "  backup   - Create backup of current dotfiles"
    echo "  migrate  - Migrate current dotfiles to YADM"
    echo "  status   - Show YADM status"
    echo "  sync     - Sync with remote repository"
    echo "  help     - Show this help"
    echo ""
}

# Initialize YADM repository
init_yadm() {
    print_status "Initializing YADM repository..."

    if [ -d "$HOME/.local/share/yadm/repo.git" ]; then
        print_warning "YADM repository already exists"
        return 0
    fi

    # Initialize yadm
    yadm init

    # Create .yadm/bootstrap script for automated setup
    mkdir -p "$HOME/.config/yadm"

    cat > "$HOME/.config/yadm/bootstrap" << 'EOF'
#!/bin/bash

# YADM Bootstrap Script
# This script runs after yadm clone/pull to setup the environment

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}[BOOTSTRAP]${NC} Starting post-clone setup..."

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo -e "${BLUE}[BOOTSTRAP]${NC} Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

# Install zsh plugins
echo -e "${BLUE}[BOOTSTRAP]${NC} Installing zsh plugins..."
ZSH_CUSTOM=${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions $ZSH_CUSTOM/plugins/zsh-autosuggestions
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting
fi

# Install Tmux Plugin Manager
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo -e "${BLUE}[BOOTSTRAP]${NC} Installing Tmux Plugin Manager..."
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

# Setup VS Code extensions if VS Code is installed
if command -v code &> /dev/null; then
    echo -e "${BLUE}[BOOTSTRAP]${NC} Installing VS Code extensions..."
    if [ -f "$HOME/.config/vscode-extensions.sh" ]; then
        bash "$HOME/.config/vscode-extensions.sh"
    fi
fi

# Install modern CLI tools if script exists
if [ -f "$HOME/.config/setup-modern-cli.sh" ]; then
    echo -e "${BLUE}[BOOTSTRAP]${NC} Installing modern CLI tools..."
    bash "$HOME/.config/setup-modern-cli.sh"
fi

# Make utility scripts executable
find "$HOME/bin" -name "*.sh" -type f -exec chmod +x {} \; 2>/dev/null || true

echo -e "${GREEN}[BOOTSTRAP]${NC} Setup completed! Please restart your terminal."
EOF

    chmod +x "$HOME/.config/yadm/bootstrap"

    # Create .yadmignore to exclude certain files
    cat > "$HOME/.yadmignore" << 'EOF'
# YADM ignore file
.git/
.DS_Store
Thumbs.db
*.log
*.tmp
.cache/
node_modules/
vendor/
.env
.env.local
.vscode/
.idea/
EOF

    print_success "YADM repository initialized"
}

# Create backup of current dotfiles
backup_dotfiles() {
    print_status "Creating backup of current dotfiles..."

    BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$BACKUP_DIR"

    # List of important config files to backup
    CONFIGS=(
        ".zshrc"
        ".bashrc"
        ".gitconfig"
        ".tmux.conf"
        ".vimrc"
        ".config/nvim"
        ".config/Code"
        ".ssh/config"
    )

    for config in "${CONFIGS[@]}"; do
        if [ -e "$HOME/$config" ]; then
            print_status "Backing up $config..."
            cp -r "$HOME/$config" "$BACKUP_DIR/"
        fi
    done

    print_success "Backup created at: $BACKUP_DIR"
}

# Migrate current dotfiles to YADM
migrate_to_yadm() {
    print_status "Migrating current dotfiles to YADM..."

    # Create backup first
    backup_dotfiles

    # Initialize YADM if not done
    if [ ! -d "$HOME/.local/share/yadm/repo.git" ]; then
        init_yadm
    fi

    # Add current dotfiles to YADM
    CONFIG_FILES=(
        ".zshrc"
        ".gitconfig"
        ".tmux.conf"
        ".config/nvim/init.lua"
        ".config/starship.toml"
    )

    for file in "${CONFIG_FILES[@]}"; do
        if [ -e "$HOME/$file" ]; then
            print_status "Adding $file to YADM..."
            yadm add "$HOME/$file"
        fi
    done

    # Add utility scripts
    if [ -d "$HOME/bin" ]; then
        print_status "Adding utility scripts..."
        yadm add "$HOME/bin/"*
    fi

    # Commit initial setup
    yadm commit -m "Initial dotfiles migration to YADM"

    print_success "Migration to YADM completed"
}

# Show YADM status
show_yadm_status() {
    print_status "YADM Repository Status:"

    if [ ! -d "$HOME/.local/share/yadm/repo.git" ]; then
        print_warning "YADM repository not initialized"
        return 1
    fi

    echo ""
    echo "📁 Repository status:"
    yadm status

    echo ""
    echo "📊 Recent commits:"
    yadm log --oneline -10

    echo ""
    echo "🔗 Remote repositories:"
    yadm remote -v

    echo ""
    echo "📋 Tracked files:"
    yadm list -a
}

# Sync with remote repository
sync_yadm() {
    print_status "Syncing YADM repository..."

    if [ ! -d "$HOME/.local/share/yadm/repo.git" ]; then
        print_error "YADM repository not initialized"
        return 1
    fi

    # Pull latest changes
    print_status "Pulling latest changes..."
    yadm pull

    # Run bootstrap if it exists
    if [ -f "$HOME/.config/yadm/bootstrap" ]; then
        print_status "Running bootstrap script..."
        "$HOME/.config/yadm/bootstrap"
    fi

    print_success "YADM sync completed"
}

# Setup YADM with GitHub repository
setup_github_remote() {
    print_status "Setting up GitHub remote for YADM..."

    read -p "Enter your GitHub username: " github_user
    read -p "Enter repository name (default: dotfiles): " repo_name
    repo_name=${repo_name:-dotfiles}

    # Add GitHub remote
    yadm remote add origin "https://github.com/$github_user/$repo_name.git"

    print_success "GitHub remote added: https://github.com/$github_user/$repo_name.git"
    print_status "Don't forget to create the repository on GitHub and push:"
    echo "  yadm push -u origin main"
}

# Create convenience aliases for YADM
create_yadm_aliases() {
    print_status "Creating YADM aliases..."

    cat >> "$HOME/.zshrc" << 'EOF'

# YADM aliases for dotfiles management
alias yd='yadm'
alias yds='yadm status'
alias yda='yadm add'
alias ydc='yadm commit'
alias ydp='yadm push'
alias ydpl='yadm pull'
alias ydl='yadm log --oneline -10'
alias ydd='yadm diff'

# Dotfiles management functions
dotfiles-sync() {
    yadm add -u
    yadm commit -m "Update dotfiles $(date '+%Y-%m-%d %H:%M')"
    yadm push
}

dotfiles-backup() {
    local backup_dir="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
    mkdir -p "$backup_dir"
    yadm archive "$backup_dir/dotfiles-backup.tar.gz"
    echo "Backup created: $backup_dir/dotfiles-backup.tar.gz"
}

dotfiles-restore() {
    if [ -z "$1" ]; then
        echo "Usage: dotfiles-restore <backup-file>"
        return 1
    fi
    tar -xzf "$1" -C "$HOME"
    echo "Dotfiles restored from: $1"
}
EOF

    print_success "YADM aliases created"
}

# Main command handler
case "${1:-help}" in
    "init")
        init_yadm
        create_yadm_aliases
        ;;
    "backup")
        backup_dotfiles
        ;;
    "migrate")
        migrate_to_yadm
        create_yadm_aliases
        ;;
    "status")
        show_yadm_status
        ;;
    "sync")
        sync_yadm
        ;;
    "github")
        setup_github_remote
        ;;
    "help"|*)
        show_help
        ;;
esac
