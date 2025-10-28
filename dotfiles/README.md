# Deepin OS 25 Dotfiles - Professional Development Environment

🚀 Modern, comprehensive dotfiles configuration for Deepin OS 25, professionally optimized for fullstack development on LG laptops.

## ✨ Features

### 🐚 Modern Shell Experience
- **Fish Shell**: Modern shell with intelligent autocompletion
- **Starship Prompt**: Fast, customizable prompt with Git integration
- **Fisher Plugin Manager**: Easy plugin management
- **Custom Functions**: Enhanced workflow with custom commands

### 💻 Development Environment
- **LazyVim IDE**: Professional Neovim distribution based on lazy-nvim-ide
- **Multi-language LSP**: PHP (Laravel/Symfony), Go, Vue.js, TypeScript, Python
- **Advanced Debugging**: DAP support for PHP, Go, Node.js debugging
- **Database Integration**: Built-in database management with DBUI
- **Project Management**: Session persistence and project switching
- **VS Code Integration**: Enhanced settings with Catppuccin theme
- **Bob Version Manager**: Easy Neovim version management

### 🛠️ Modern CLI Tools
- **exa**: Beautiful ls replacement with Git integration
- **bat**: Cat with syntax highlighting and Git integration
- **fd**: Fast and user-friendly find alternative
- **ripgrep**: Ultra-fast text search
- **delta**: Enhanced Git diff viewer
- **zoxide**: Smart cd that learns your habits
- **yazi**: Modern terminal file manager

### 🎨 Consistent Theming
- **Catppuccin Theme**: Consistent across all applications
- **Unified Experience**: Coordinated colors and styling
- **Eye-friendly**: Dark theme optimized for long coding sessions

### ⚡ System Optimization
- **auto-cpufreq**: Automatic CPU frequency scaling
- **TLP**: Advanced power management
- **topgrade**: Keep all tools updated automatically
- **Laptop Optimizations**: Battery life and thermal management

### 🔧 Terminal Multiplexing
- **Tmux**: Enhanced terminal multiplexer
- **TPM**: Plugin manager for Tmux
- **Custom Keybindings**: Optimized for development workflow
- **Status Bar**: System information and Git status

### 🌐 Browser Integration
- **Deepin Browser Backup**: Complete backup and restore system
- **Bookmarks Sync**: Preserve all bookmarks across installations
- **Extensions Management**: Backup and restore all extensions
- **Settings Preservation**: Maintain browser preferences

## 🚀 Quick Install

```bash
# Clone the repository
git clone https://github.com/yourusername/deepin-dotfiles ~/.dotfiles
cd ~/.dotfiles

# Make installation script executable and run
chmod +x install.sh
./install.sh
```

The installation script will automatically:
1. 📦 Install essential packages and dependencies
2. 🔧 Configure Fish shell as default
3. ⚙️ Set up LazyVim with all plugins
4. 🎨 Apply Catppuccin theme system-wide
5. 🛠️ Install and configure all modern CLI tools
6. ⚡ Apply system optimizations for laptop use
7. 🔄 Set up automatic updates and maintenance
8. 🌐 Optionally backup Deepin Browser data

## 🔄 Update and Maintenance

Keep your development environment up-to-date with these commands:

```bash
# Full comprehensive update (monthly recommended)
./update.sh

# Quick daily update
./quick-update.sh

# Or use the universal updater
topgrade
```

The update script will automatically:
- 🔄 Update all system packages
- 📦 Update package managers (npm, pip, composer, cargo)
- 🛠️ Update development tools (Go, Node.js, Rust)
- 🔌 Update editor plugins (Neovim, VS Code)
- 🐚 Update shell configurations and plugins
- 🧹 Clean up caches and optimize system
- 💾 Create backup before major changes

## 📁 Configuration Structure

```
dotfiles/
├── config/
│   ├── fish/                    # Fish shell configuration
│   │   ├── config.fish          # Main Fish config
│   │   ├── abbreviations.fish   # Command abbreviations
│   │   ├── user_variables.fish  # Environment variables
│   │   └── functions/           # Custom Fish functions
│   ├── nvim/                    # LazyVim IDE configuration
│   │   ├── lua/
│   │   │   ├── config/          # Core LazyVim settings
│   │   │   └── plugins/         # Plugin configurations
│   │   │       ├── deepin-config.lua      # Deepin OS optimizations
│   │   │       ├── deepin-keymaps.lua     # Custom keybindings
│   │   │       ├── deepin-colorscheme.lua # Theme configurations
│   │   │       └── extras/      # Additional plugin configs
│   │   ├── init.lua             # Neovim entry point
│   │   └── README.md            # LazyVim IDE documentation
│   ├── tmux/                    # Tmux configuration
│   │   └── .tmux.conf           # Tmux settings with plugins
│   ├── yazi/                    # Yazi file manager
│   │   ├── yazi.toml            # Main configuration
│   │   ├── keymap.toml          # Key bindings
│   │   ├── theme.toml           # Catppuccin theme
│   │   └── init.lua             # Plugin configuration
│   └── vscode/                  # VS Code settings
│       └── settings.json        # Enhanced VS Code config
│   └── browser/                 # Deepin Browser backup
│       ├── README.md            # Browser backup guide
│       ├── Default/             # Bookmarks and preferences
│       ├── Extensions/          # Backed up extensions
│       └── extensions_list.txt  # Extensions inventory
├── scripts/
│   └── setup/                   # Individual setup scripts
│       ├── setup-fish.sh        # Fish shell setup
│       ├── setup-tmux.sh        # Tmux setup
│       ├── setup-yazi.sh        # Yazi setup
│       ├── setup-go.sh          # Go development
│       ├── setup-php.sh         # PHP development
│       ├── setup-node.sh        # Node.js development
│       ├── setup-browser-backup.sh     # Browser backup
│       ├── setup-browser-restore.sh    # Browser restore
│       └── setup-system-optimization.sh
├── install.sh                   # Main installation script
├── update.sh                    # Comprehensive update script
└── quick-update.sh              # Quick daily update script
```

## 🛠️ Development Languages Support

### PHP Development
- **Intelephense LSP**: Advanced PHP language server
- **Laravel Support**: Laravel-specific snippets and tools
- **Symfony Support**: Symfony development tools
- **Composer Integration**: Dependency management

### Go Development
- **gopls LSP**: Official Go language server
- **Go Tools**: gofmt, goimports, golint integration
- **Debugging Support**: Delve debugger integration
- **Module Management**: Go modules support

### Frontend Development
- **Vue.js**: Volar language server and tools
- **TypeScript**: Full TypeScript support
- **JavaScript**: Modern JS development tools
- **CSS/SCSS**: Enhanced styling support

### Python Development
- **Pylsp**: Python language server
- **Black**: Code formatting
- **Flake8**: Linting and style checking
- **Virtual Environment**: Poetry and venv support

### Rust Development
- **rust-analyzer**: Advanced Rust language server
- **Cargo Integration**: Build and package management
- **Clippy**: Rust linter integration

## 💡 Key Features by Component

### Fish Shell Enhancements
- Smart autocompletion with syntax highlighting
- Custom abbreviations for common commands
- Git integration in prompt and commands
- Project-specific environment variables
- Enhanced history search and navigation

### LazyVim Configuration
- LSP auto-installation for all supported languages
- Treesitter for enhanced syntax highlighting
- Telescope for fuzzy finding files, symbols, and text
- Neo-tree for file exploration
- Git integration with gitsigns and lazygit
- Code formatting and linting on save
- Debugging support with nvim-dap

### System Optimizations
- Automatic CPU frequency scaling for battery life
- Advanced power management with TLP
- System cleanup and maintenance tools
- Font installation for better terminal experience
- Performance monitoring and optimization

## 🔧 Manual Component Setup

If you prefer to install components individually:

```bash
# Shell environment
./scripts/setup/setup-fish.sh

# Development environment
./scripts/setup/setup-neovim.sh

# Terminal tools
./scripts/setup/setup-tmux.sh
./scripts/setup/setup-yazi.sh

# Language-specific tools
./scripts/setup/setup-go.sh
./scripts/setup/setup-php.sh
./scripts/setup/setup-node.sh

# Browser backup and restore
./scripts/setup/setup-browser-backup.sh backup
./scripts/setup/setup-browser-restore.sh

# System optimization
./scripts/setup/setup-system-optimization.sh
```

## 🌐 Browser Management

### Backup Current Browser Data
```bash
# Backup bookmarks, extensions, and settings
./scripts/setup/setup-browser-backup.sh backup

# View backed up extensions
./scripts/setup/setup-browser-backup.sh list
```

### Restore Browser on New Machine
```bash
# Automatically install Deepin Browser and restore data
./scripts/setup/setup-browser-restore.sh
```

### What Gets Backed Up
- **Bookmarks**: All bookmark folders and items
- **Extensions**: Complete extension data and settings
- **Preferences**: Browser settings and configurations
- **Local State**: Important browser state information

## ⚙️ Customization Guide

### Fish Shell
Edit `config/fish/config.fish` for:
- Custom functions and aliases
- Environment variables
- Path modifications
- Plugin configurations

### LazyVim
Customize in `config/nvim/lua/`:
- `config/options.lua`: Neovim options
- `config/keymaps.lua`: Custom key mappings
- `plugins/`: Add or modify plugin configurations

### Tmux
Modify `config/tmux/.tmux.conf` for:
- Custom key bindings
- Status bar configuration
- Plugin settings

### VS Code
Edit `config/vscode/settings.json` for:
- Editor preferences
- Extension settings
- Theme customizations

## 🔄 Maintenance

The dotfiles include automatic maintenance tools:

```bash
# Update all tools and packages
topgrade

# Update Fish plugins
fisher update

# Update Tmux plugins
~/.tmux/plugins/tpm/bin/update_plugins all

# Update Neovim plugins
nvim --headless "+Lazy! sync" +qa
```

## 📱 System Requirements

- **OS**: Deepin OS 25 (or compatible Debian-based distribution)
- **Hardware**: LG laptop (optimizations included)
- **Dependencies**: Git, curl, and internet connection
- **Disk Space**: ~2GB for all tools and configurations
- **Memory**: 4GB+ recommended for full development environment

## 🆘 Troubleshooting

### Common Issues

1. **Fish shell not default**: Run `chsh -s $(which fish)`
2. **LSP not working**: Check `:LspInfo` in Neovim
3. **Tmux plugins not loading**: Press `prefix + I` to install
4. **Font issues**: Install Nerd Fonts with `./scripts/setup/setup-fonts.sh`

### Getting Help

- Check the individual configuration files for inline documentation
- Review the setup scripts for component-specific instructions
- Use `:checkhealth` in Neovim for diagnostics

## 🤝 Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Test your changes on Deepin OS 25
4. Submit a pull request with detailed description

## 📄 License

MIT License - Feel free to use, modify, and distribute as needed.

---

🎯 **Ready to supercharge your development environment?** Run `./install.sh` and experience the power of modern dotfiles!
