# Deepin OS 25 Dotfiles - AI Agent Instructions

## Project Overview

This is a comprehensive dotfiles repository for Deepin OS 25, optimized for fullstack development on LG laptops. The project creates a unified development environment with modern CLI tools, Catppuccin theming, and professional IDE configurations.

## Architecture & Core Components

### Setup System

- **Primary Entry**: `./install.sh` - orchestrates complete environment setup
- **Modular Scripts**: `scripts/setup/` contains individual component installers
- **Config Linking**: `scripts/setup/link-configs.sh` handles symlink management with automatic backup

### Shell Environment (Fish + Modern CLI)

- **Shell**: Fish with Starship prompt, configured in `config/fish/config.fish`
- **Modern Tools**: Uses `exa` (ls), `bat` (cat), `fd` (find), `rg` (grep), `zoxide` (cd)
- **Abbreviations**: Extensive shortcuts in `config/fish/abbreviations.fish` (e.g., `art` → `php artisan`)
- **Functions**: Custom functions in `config/fish/functions/` including `dev-env.fish` for project setup

### Development Environment

- **Editor**: LazyVim-based Neovim with language servers for PHP/Laravel, Go, Vue.js, TypeScript, Python
- **Config**: `config/nvim/lua/config/lazy.lua` imports LazyVim + custom plugins
- **File Manager**: Yazi integration replaces oil.nvim (`config/nvim/lua/plugins/yazi-integration.lua`)
- **Multiplexer**: Tmux with custom session management (`config/tmux/dev-session`)

### Browser Integration

- **Backup System**: Complete Deepin Browser backup/restore in `config/browser/`
- **Includes**: Bookmarks, extensions, preferences with restore scripts
- **Workflow**: `setup-browser-backup.sh backup` → commit → `setup-browser-restore.sh` on new system

## Critical Workflows

### Initial Setup

```bash
./install.sh  # Full environment setup
./scripts/setup/setup-modern-cli.sh  # CLI tools only
```

### Project Management

```bash
dev-env new laravel myproject  # Create new project via dev-env.sh
dev-env start myproject        # Start development environment
```

### Fish Shell Patterns

- Use abbreviations: `gs` (git status), `art` (php artisan), `dc` (docker-compose)
- Project detection: `dev-env.fish` auto-detects Laravel/Go/Node.js projects
- Modern CLI aliases: `ls`→`exa`, `cat`→`bat`, `find`→`fd`

### Neovim Workflow

- **File Manager**: `<leader>e` opens Yazi (not oil.nvim)
- **Database**: Built-in DBUI for database management
- **Testing**: Neotest integration for PHP/Go/Node.js
- **Language Support**: Full LSP for Laravel, Symfony, Vue.js development

## Key Conventions

### Directory Structure

- `config/` - All application configurations
- `scripts/setup/` - Installation scripts for specific components
- `scripts/utils/` - Utility scripts (linked to `~/bin/`)
- Each config has its own directory (fish, nvim, tmux, etc.)

### Symlink Strategy

- Uses `link-configs.sh` to create symlinks with automatic backups
- Target locations follow XDG Base Directory specification
- Broken/existing links are handled gracefully

### Tool Integration

- **Theme Consistency**: Catppuccin theme across all applications
- **CLI Replacement**: Modern alternatives with aliases (never override base commands)
- **Cross-tool Integration**: Yazi↔Neovim, Fish↔modern CLI tools

### Development Environment Detection

- `dev-env.fish` and `dev-env.sh` auto-detect project types:
  - Laravel: `composer.json` + `artisan`
  - Go: `go.mod`
  - Node.js: `package.json`
- Automatic dependency installation and environment setup

## Editing Guidelines

### Adding New Tools

1. Create setup script in `scripts/setup/setup-[tool].sh`
2. Add configuration in `config/[tool]/`
3. Update `scripts/setup/link-configs.sh` for symlinking
4. Add to main `install.sh` orchestration

### Fish Shell Changes

- Add abbreviations to `config/fish/abbreviations.fish`
- Create functions in `config/fish/functions/`
- Update `config/fish/config.fish` for environment variables

### Neovim Plugins

- Add custom plugins to `config/nvim/lua/plugins/`
- Import LazyVim extras in `config/nvim/lua/config/lazy.lua`
- Follow LazyVim plugin structure and naming conventions

### Browser Integration

- Backup data stored in `config/browser/`
- Use `setup-browser-backup.sh` and `setup-browser-restore.sh`
- Maintain `extensions_list.txt` for documentation

## Testing & Validation

- Test installation on fresh Deepin OS 25 system
- Verify symlinks point to correct locations
- Ensure all abbreviations and functions work in Fish
- Validate LazyVim plugins load without errors
- Test browser backup/restore cycle
