#!/bin/bash

# Dotfiles Quick Start Guide
# This script demonstrates common usage patterns for the enhanced dotfiles

echo "🚀 Dotfiles Quick Start Guide"
echo "=============================="

echo
echo "📦 1. Installation Commands"
echo "---------------------------"
echo "# Complete installation:"
echo "./install.sh"
echo
echo "# Install only modern CLI tools:"
echo "./scripts/setup/setup-modern-cli.sh"
echo
echo "# Initialize YADM (optional):"
echo "./scripts/utils/yadm-manager.sh init"

echo
echo "🔧 2. Modern CLI Tools Usage"
echo "----------------------------"
echo "# Enhanced file listing:"
echo "ls        # Uses exa with icons"
echo "ll        # Long format with icons"
echo "tree      # Tree view with icons"
echo
echo "# Better file viewing:"
echo "cat file.txt    # Uses bat with syntax highlighting"
echo "bat --style=numbers file.py  # With line numbers"
echo
echo "# Fast searching:"
echo "find . -name '*.php'     # Uses fd"
echo "fd '\.php$'             # Direct fd usage"
echo "grep 'function'         # Uses ripgrep"
echo "rg 'function' --type php # Search only PHP files"
echo
echo "# Smart navigation:"
echo "cd ~/Development        # Traditional cd"
echo "z dev                   # Smart jump with zoxide"
echo "z -i                    # Interactive selection"
echo
echo "# File management:"
echo "yazi                    # Open file manager"
echo "fm                      # Alias for yazi"

echo
echo "📝 3. Git Enhancements"
echo "----------------------"
echo "# Beautiful git diff:"
echo "git diff                # Uses delta for highlighting"
echo "git log --oneline       # Enhanced log view"
echo "git status              # Alias: gst"
echo "git commit -m 'msg'     # Alias: gcm 'msg'"

echo
echo "🔄 4. YADM Management"
echo "--------------------"
echo "# Initialize YADM repository:"
echo "./scripts/utils/yadm-manager.sh init"
echo
echo "# Sync with remote:"
echo "./scripts/utils/yadm-manager.sh sync"
echo
echo "# Create backup:"
echo "./scripts/utils/yadm-manager.sh backup"
echo
echo "# Restore from backup:"
echo "./scripts/utils/yadm-manager.sh restore"

echo
echo "⚡ 5. Development Workflow"
echo "-------------------------"
echo "# Start development environment:"
echo "dev-env                 # Setup development environment"
echo
echo "# Monitor battery:"
echo "battery-status          # Check battery optimization"
echo
echo "# Docker utilities:"
echo "dps                     # Docker ps with formatting"
echo "dstop                   # Stop all containers"
echo "dclean                  # Clean Docker system"

echo
echo "🎨 6. Terminal Customization"
echo "----------------------------"
echo "# The dotfiles include:"
echo "- Starship prompt (fast and beautiful)"
echo "- Modern tool aliases in .zshrc"
echo "- Enhanced completion support"
echo "- Color schemes for all tools"

echo
echo "🔍 7. Useful Keyboard Shortcuts"
echo "-------------------------------"
echo "# In yazi file manager:"
echo "h/j/k/l  - Navigation (vim-style)"
echo "Enter    - Open file/directory"
echo "q        - Quit"
echo "Space    - Select files"
echo
echo "# In zsh with modern tools:"
echo "Ctrl+R   - History search (enhanced with zoxide)"
echo "Ctrl+T   - File search with fd"
echo "Alt+C    - Directory navigation"

echo
echo "📚 8. Learning Resources"
echo "-----------------------"
echo "# Tool documentation:"
echo "exa --help             # File listing options"
echo "bat --help             # File viewing options"
echo "fd --help              # Search options"
echo "rg --help              # Grep options"
echo "zoxide --help          # Navigation options"
echo "yazi --help            # File manager options"

echo
echo "✨ Quick Tips:"
echo "- All traditional commands (ls, cat, find, grep, cd) work but use modern tools"
echo "- Use 'z' for smart directory jumping after visiting directories"
echo "- Use 'bat' instead of 'cat' for syntax highlighting"
echo "- Use 'fd' instead of 'find' for faster searching"
echo "- Use 'rg' instead of 'grep' for faster text searching"
echo "- Use 'yazi' for visual file management"

echo
echo "🎯 Ready to go! Your enhanced development environment is configured."
echo "For more details, check README.md and CHANGELOG.md"
