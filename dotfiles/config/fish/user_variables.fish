# User-specific variables for Fish shell
# Based on best practices from dotfiles-docs.vercel.app

# Editor preferences
set -xg EDITOR nvim
set -xg VISUAL nvim

# Pager configuration
set -xg PAGER less
set -xg LESS '-R -S -M +Gg'

# Browser
set -xg BROWSER firefox

# Language and locale
set -xg LANG en_US.UTF-8
set -xg LC_ALL en_US.UTF-8

# XDG Base Directory specification
set -xg XDG_CONFIG_HOME $HOME/.config
set -xg XDG_DATA_HOME $HOME/.local/share
set -xg XDG_CACHE_HOME $HOME/.cache
set -xg XDG_STATE_HOME $HOME/.local/state

# Development paths
set -xg GOPATH $XDG_DATA_HOME/go
set -xg GOBIN $HOME/.local/bin
set -xg COMPOSER_HOME $XDG_CONFIG_HOME/composer
set -xg NPM_CONFIG_USERCONFIG $XDG_CONFIG_HOME/npm/npmrc
set -xg NODE_REPL_HISTORY $XDG_STATE_HOME/node_repl_history

# Docker configuration
set -xg DOCKER_CONFIG $XDG_CONFIG_HOME/docker

# History configuration
set -xg HISTSIZE 10000
set -xg HISTFILESIZE 20000

# fzf configuration
set -xg FZF_DEFAULT_OPTS '--height 40% --layout=reverse --border --preview "bat --color=always --style=numbers --line-range=:500 {}" --preview-window=right:50%:wrap'

# bat configuration
set -xg BAT_THEME 'Catppuccin-macchiato'
set -xg BAT_STYLE 'numbers,changes,header'

# ripgrep configuration
set -xg RIPGREP_CONFIG_PATH $XDG_CONFIG_HOME/ripgrep/config

# Development-specific variables
set -xg PHP_CS_FIXER_IGNORE_ENV 1
set -xg COMPOSER_MEMORY_LIMIT -1

# PATH additions - these will be handled in config.fish with fish_add_path
# This file is for exported variables only
