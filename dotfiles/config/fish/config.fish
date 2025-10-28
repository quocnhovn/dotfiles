# Fish shell configuration for development
# Based on best practices from dotfiles-docs.vercel.app

# Initialize Starship prompt
if command -v starship >/dev/null 2>&1
    starship init fish | source
end

# XDG Base Directory support
set -x XDG_CONFIG_HOME ~/.config
set -x XDG_DATA_HOME ~/.local/share
set -x XDG_CACHE_HOME ~/.cache
set -x XDG_STATE_HOME ~/.local/state

# Development environment variables
set -x EDITOR nvim
set -x VISUAL nvim
set -x PAGER less
set -x BROWSER firefox

# Language specific paths
set -x GOPATH ~/.local/share/go
set -x GOBIN ~/.local/bin
set -x COMPOSER_HOME ~/.config/composer
set -x NPM_CONFIG_USERCONFIG ~/.config/npm/npmrc

# Add local bins to PATH
fish_add_path ~/.local/bin
fish_add_path ~/.config/composer/vendor/bin
fish_add_path ~/.local/share/go/bin
fish_add_path /usr/local/go/bin

# Modern CLI tools setup
if command -v exa >/dev/null 2>&1
    alias ls='exa --icons'
    alias ll='exa -la --icons'
    alias tree='exa --tree --icons'
end

if command -v bat >/dev/null 2>&1
    alias cat='bat'
    set -x MANPAGER "sh -c 'col -bx | bat -l man -p'"
end

if command -v fd >/dev/null 2>&1
    alias find='fd'
end

if command -v rg >/dev/null 2>&1
    alias grep='rg'
end

if command -v yazi >/dev/null 2>&1
    alias fm='yazi'
end

# Git aliases
alias gst='git status'
alias gco='git checkout'
alias gcm='git commit -m'
alias gps='git push'
alias gpl='git pull'
alias gd='git diff'
alias ga='git add'
alias gb='git branch'
alias gl='git log --oneline'

# System aliases
alias update='sudo apt update && sudo apt upgrade'
alias install='sudo apt install'
alias search='apt search'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Docker aliases
alias dps='docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Image}}"'
alias dstop='docker stop (docker ps -q)'
alias dclean='docker system prune -f'

# Development aliases
alias serve='python3 -m http.server'
alias laravel='php artisan'
alias art='php artisan'
alias composer-update='composer update --no-dev --optimize-autoloader'

# Battery and system monitoring
alias battery='cat /sys/class/power_supply/BAT*/capacity'
alias temp='sensors | grep Core'
alias wifi='nmcli dev wifi'

# Custom functions will be loaded from functions directory

# Enable zoxide if available
if command -v zoxide >/dev/null 2>&1
    zoxide init fish | source
    alias cd='z'
    alias zi='z -i'
end

# LS_COLORS with vivid if available
if command -v vivid >/dev/null 2>&1
    set -x LS_COLORS (vivid generate catppuccin-macchiato)
end

# fzf configuration
if command -v fzf >/dev/null 2>&1
    set -x FZF_DEFAULT_OPTS "--height 40% --layout=reverse --border"

    if command -v fd >/dev/null 2>&1
        set -x FZF_DEFAULT_COMMAND 'fd --type f --hidden --follow --exclude .git'
        set -x FZF_CTRL_T_COMMAND $FZF_DEFAULT_COMMAND
    end
end

# Load user variables if exists
if test -f ~/.config/fish/user_variables.fish
    source ~/.config/fish/user_variables.fish
end

# Load abbreviations if exists
if test -f ~/.config/fish/abbreviations.fish
    source ~/.config/fish/abbreviations.fish
end
