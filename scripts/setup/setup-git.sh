#!/bin/bash

# Git Setup Script
# This script configures Git with optimal settings for development

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[GIT]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_status "Setting up Git configuration..."

# Backup existing Git config
if [ -f "$HOME/.gitconfig" ]; then
    print_status "Backing up existing Git configuration..."
    cp "$HOME/.gitconfig" "$HOME/.gitconfig.backup"
fi

# Copy Git configuration files
cp "$DOTFILES_DIR/config/git/.gitconfig" "$HOME/.gitconfig"
cp "$DOTFILES_DIR/config/git/.gitignore_global" "$HOME/.gitignore_global"

# Prompt for user information
echo ""
read -p "Enter your full name for Git: " git_name
read -p "Enter your email for Git: " git_email
read -p "Enter your GitHub username (optional): " github_username

# Configure Git user information
git config --global user.name "$git_name"
git config --global user.email "$git_email"

if [ -n "$github_username" ]; then
    git config --global github.user "$github_username"
fi

# Install Git LFS if not already installed
if ! command -v git-lfs &> /dev/null; then
    print_status "Installing Git LFS..."
    curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash
    sudo apt-get install git-lfs
    git lfs install
fi

# Install diff-so-fancy for better diffs
if ! command -v diff-so-fancy &> /dev/null; then
    print_status "Installing diff-so-fancy..."
    sudo npm install -g diff-so-fancy
    git config --global core.pager "diff-so-fancy | less --tabs=4 -RFX"
    git config --global color.ui true
    git config --global color.diff-highlight.oldNormal "red bold"
    git config --global color.diff-highlight.oldHighlight "red bold 52"
    git config --global color.diff-highlight.newNormal "green bold"
    git config --global color.diff-highlight.newHighlight "green bold 22"
fi

# Install lazygit for better Git UI
if ! command -v lazygit &> /dev/null; then
    print_status "Installing lazygit..."
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
    rm lazygit.tar.gz lazygit
fi

# Create useful Git templates
mkdir -p ~/.git_template/hooks

# Create commit message template
cat > ~/.git_template/commit_template << 'EOF'

# <type>(<scope>): <subject>
#
# <body>
#
# <footer>

# Type should be one of the following:
# * feat (new feature)
# * fix (bug fix)
# * docs (documentation)
# * style (formatting, missing semi colons, etc; no code change)
# * refactor (refactoring production code)
# * test (adding tests, refactoring test; no production code change)
# * chore (updating build tasks, package manager configs, etc; no production code change)
EOF

git config --global commit.template ~/.git_template/commit_template

# Create useful aliases for Laravel development
git config --global alias.feature "checkout -b feature/"
git config --global alias.hotfix "checkout -b hotfix/"
git config --global alias.release "checkout -b release/"

# Create useful aliases for deployment
git config --global alias.deploy "push origin main"
git config --global alias.prod "push production main"

print_success "Git configuration completed!"
print_status "Configured user: $git_name <$git_email>"
print_status "Global gitignore: ~/.gitignore_global"
print_status "Commit template: ~/.git_template/commit_template"
print_status "Git LFS installed and configured"
print_status "diff-so-fancy installed for better diffs"
print_status "lazygit installed for enhanced Git UI"

echo ""
print_status "Useful Git aliases configured:"
echo "  git lg    - Pretty log with graph"
echo "  git wip   - Quick work-in-progress commit"
echo "  git unwip - Undo last WIP commit"
echo "  git cleanup - Delete merged branches"
echo "  git today - Show today's commits"
echo "  git feature <name> - Create feature branch"
echo "  git deploy - Deploy to main branch"

echo ""
print_warning "Remember to:"
echo "  1. Set up SSH keys for GitHub: ssh-keygen -t ed25519 -C \"$git_email\""
echo "  2. Add SSH key to GitHub account"
echo "  3. Test connection: ssh -T git@github.com"
