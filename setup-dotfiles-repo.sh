#!/bin/bash

# Script to setup dotfiles as independent Git repository
# Usage: ./setup-dotfiles-repo.sh

set -e

DOTFILES_DIR="/home/quocnho/Development/OS/dotfiles"
REPO_URL="https://github.com/quocnhovn/dotfiles.git"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${BLUE}🚀 Setting up dotfiles as independent repository...${NC}"

# Navigate to dotfiles directory
cd "$DOTFILES_DIR" || {
    echo -e "${RED}❌ Dotfiles directory not found: $DOTFILES_DIR${NC}"
    exit 1
}

# Initialize git if not already done
if [ ! -d ".git" ]; then
    echo -e "${YELLOW}📁 Initializing git repository...${NC}"
    git init
    echo -e "${GREEN}✅ Git repository initialized${NC}"
else
    echo -e "${YELLOW}⚠️  Git repository already exists${NC}"
fi

# Create .gitignore
echo -e "${YELLOW}📝 Creating .gitignore...${NC}"
cat > .gitignore << 'EOF'
# System files
.DS_Store
Thumbs.db
*~

# Backup files
*.bak
*.backup
*-backup-*

# Log files
*.log

# Temporary files
*.tmp
*.temp

# IDE/Editor files
.vscode/
.idea/

# OS specific
.Trash/
.cache/

# Neovim specific
config/nvim/lazy-lock.json
config/nvim/.luarc.json

# Fish shell
config/fish/fish_variables
EOF

# Check if remote already exists
if git remote | grep -q origin; then
    echo -e "${YELLOW}⚠️  Remote origin already exists, updating...${NC}"
    git remote set-url origin "$REPO_URL"
else
    echo -e "${YELLOW}🔗 Adding remote origin...${NC}"
    git remote add origin "$REPO_URL"
fi

# Add all files
echo -e "${YELLOW}📂 Adding files...${NC}"
git add .

# Create initial commit
echo -e "${YELLOW}💾 Creating initial commit...${NC}"
git commit -m "🎉 Initial commit: Complete Deepin OS 25 dotfiles

✨ Features:
- Complete Fish shell setup with modern CLI tools
- LazyVim configuration with custom plugins
- Obsidian.nvim integration for note-taking
- Tmux configuration with session management
- Comprehensive setup scripts for automated installation
- Browser backup/restore system
- Git configurations and aliases

🛠️ Tools included:
- Modern CLI: exa, bat, fd, rg, zoxide
- Development: Neovim, tmux, git, Docker, VS Code
- Note-taking: Obsidian.nvim with templates
- Shell: Fish with Starship prompt

📁 Structure:
- config/ - Application configurations
- scripts/ - Installation and utility scripts
- system/ - System-level configurations"

# Set main branch and push
echo -e "${YELLOW}☁️  Pushing to GitHub...${NC}"
git branch -M main
git push -u origin main

echo -e "${GREEN}🎉 Dotfiles repository successfully set up!${NC}"
echo -e "${BLUE}📋 Repository details:${NC}"
echo -e "  📍 Location: $DOTFILES_DIR"
echo -e "  🔗 Remote: $REPO_URL"
echo -e "  🌿 Branch: main"

echo -e "${BLUE}🔄 Future updates:${NC}"
echo -e "  ${YELLOW}cd $DOTFILES_DIR${NC}"
echo -e "  ${YELLOW}git add . && git commit -m \"Update dotfiles\" && git push${NC}"
