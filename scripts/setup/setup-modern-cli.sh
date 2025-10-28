#!/bin/bash

# Modern CLI Tools Installation Script
# Inspired by modern dotfiles best practices

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[MODERN]${NC} $1"
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

# Install modern CLI tools
install_modern_cli() {
    print_status "Installing modern CLI tools..."

    # Ensure required dependencies are installed first
    ensure_dependencies "curl" "unzip" "dpkg"

    # Update package list
    sudo apt update

    # Install available tools from apt
    sudo apt install -y \
        fd-find \
        ripgrep \
        bat \
        fzf \
        tree \
        jq \
        httpie \
        neofetch \
        figlet \
        lolcat

    # Install exa (modern ls replacement)
    if ! command_exists exa; then
        print_status "Installing exa..."

        # Ensure curl and unzip are available
        ensure_dependencies "curl" "unzip"

        EXA_VERSION=$(curl -s "https://api.github.com/repos/ogham/exa/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        if [ -n "$EXA_VERSION" ]; then
            curl -Lo exa.zip "https://github.com/ogham/exa/releases/latest/download/exa-linux-x86_64-v${EXA_VERSION}.zip"
            unzip exa.zip
            sudo mv bin/exa /usr/local/bin/
            sudo mv man/exa.1 /usr/local/share/man/man1/ 2>/dev/null || true
            sudo mv man/exa_colors.5 /usr/local/share/man/man5/ 2>/dev/null || true
            rm -rf exa.zip bin man completions
            print_success "exa installed successfully"
        else
            print_error "Failed to get exa version"
        fi
    else
        print_success "exa already installed"
    fi

    # Install zoxide (smart cd)
    if ! command_exists zoxide; then
        print_status "Installing zoxide..."

        # Ensure curl is available
        ensure_dependencies "curl"

        curl -sS https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | bash

        # Move to system-wide location if installed locally
        if [ -f "$HOME/.local/bin/zoxide" ]; then
            sudo mv "$HOME/.local/bin/zoxide" /usr/local/bin/
        fi

        print_success "zoxide installed successfully"
    else
        print_success "zoxide already installed"
    fi

    # Install starship prompt
    if ! command_exists starship; then
        print_status "Installing starship prompt..."

        # Ensure curl is available
        ensure_dependencies "curl"

        curl -sS https://starship.rs/install.sh | sh -s -- -y
        print_success "starship installed successfully"
    else
        print_success "starship already installed"
    fi

    # Install delta (better git diff)
    if ! command_exists delta; then
        print_status "Installing git delta..."

        # Ensure required dependencies
        ensure_dependencies "curl" "dpkg"

        DELTA_VERSION=$(curl -s "https://api.github.com/repos/dandavison/delta/releases/latest" | grep -Po '"tag_name": "\K[^"]*')
        if [ -n "$DELTA_VERSION" ]; then
            curl -Lo delta.deb "https://github.com/dandavison/delta/releases/latest/download/git-delta_${DELTA_VERSION}_amd64.deb"
            sudo dpkg -i delta.deb || sudo apt-get install -f -y
            rm delta.deb
            print_success "delta installed successfully"
        else
            print_error "Failed to get delta version"
        fi
    else
        print_success "delta already installed"
    fi

    # Install yazi (file manager)
    if ! command_exists yazi; then
        print_status "Installing yazi file manager..."

        # Try cargo first if available
        if command_exists cargo; then
            cargo install --locked yazi-fm yazi-cli
            print_success "yazi installed via cargo"
        else
            print_warning "Cargo not found, installing via binary..."

            # Ensure required dependencies for binary installation
            ensure_dependencies "curl" "unzip"

            YAZI_VERSION=$(curl -s "https://api.github.com/repos/sxyazi/yazi/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
            if [ -n "$YAZI_VERSION" ]; then
                curl -Lo yazi.zip "https://github.com/sxyazi/yazi/releases/latest/download/yazi-x86_64-unknown-linux-gnu.zip"
                unzip yazi.zip
                sudo mv yazi-x86_64-unknown-linux-gnu/yazi /usr/local/bin/
                sudo mv yazi-x86_64-unknown-linux-gnu/ya /usr/local/bin/
                rm -rf yazi.zip yazi-x86_64-unknown-linux-gnu
                print_success "yazi installed via binary"
            else
                print_error "Failed to get yazi version"
            fi
        fi
    else
        print_success "yazi already installed"
    fi

    print_success "Modern CLI tools installed"
}

# Install Nerd Fonts
install_nerd_fonts() {
    print_status "Installing Nerd Fonts..."

    FONTS_DIR="$HOME/.local/share/fonts"
    mkdir -p "$FONTS_DIR"

    # Install FiraCode Nerd Font
    if [ ! -f "$FONTS_DIR/FiraCodeNerdFont-Regular.ttf" ]; then
        print_status "Installing FiraCode Nerd Font..."
        curl -Lo FiraCode.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip"
        unzip FiraCode.zip -d "$FONTS_DIR"
        rm FiraCode.zip
    fi

    # Install JetBrains Mono Nerd Font
    if [ ! -f "$FONTS_DIR/JetBrainsMonoNerdFont-Regular.ttf" ]; then
        print_status "Installing JetBrains Mono Nerd Font..."
        curl -Lo JetBrainsMono.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip"
        unzip JetBrainsMono.zip -d "$FONTS_DIR"
        rm JetBrainsMono.zip
    fi

    # Install Meslo Nerd Font
    if [ ! -f "$FONTS_DIR/MesloLGSNerdFont-Regular.ttf" ]; then
        print_status "Installing Meslo Nerd Font..."
        curl -Lo Meslo.zip "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip"
        unzip Meslo.zip -d "$FONTS_DIR"
        rm Meslo.zip
    fi

    # Refresh font cache
    fc-cache -fv
    print_success "Nerd Fonts installed"
}

# Install YADM for better dotfiles management
install_yadm() {
    print_status "Installing YADM..."

    if ! command -v yadm &> /dev/null; then
        # Install yadm
        curl -fLo /tmp/yadm https://github.com/TheLocehiliosan/yadm/raw/master/yadm
        chmod a+x /tmp/yadm
        sudo mv /tmp/yadm /usr/local/bin/yadm

        print_success "YADM installed"
    else
        print_warning "YADM already installed"
    fi
}

# Setup aliases for modern tools
setup_modern_aliases() {
    print_status "Setting up modern aliases..."

    cat >> "$HOME/.zshrc" << 'EOF'

# Modern CLI tool aliases
if command -v exa &> /dev/null; then
    alias ls='exa --icons'
    alias ll='exa -l --icons --git'
    alias la='exa -la --icons --git'
    alias lt='exa --tree --icons'
fi

if command -v bat &> /dev/null; then
    alias cat='bat --style=auto'
    alias ccat='/bin/cat'  # Original cat
fi

if command -v fd &> /dev/null; then
    alias find='fd'
fi

if command -v rg &> /dev/null; then
    alias grep='rg'
fi

if command -v zoxide &> /dev/null; then
    eval "$(zoxide init zsh)"
    alias cd='z'
    alias cdi='zi'
fi

if command -v yazi &> /dev/null; then
    alias fm='yazi'
    alias file='yazi'
fi

# Enhanced commands
alias df='df -h'
alias du='du -h'
alias free='free -h'
alias top='htop'
alias ps='ps auxf'

# Git with delta
if command -v delta &> /dev/null; then
    export GIT_PAGER='delta'
fi

# Better history
alias h='history'
alias hg='history | grep'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias ~='cd ~'

# System info
alias sysinfo='neofetch'
alias weather='curl wttr.in'
EOF

    print_success "Modern aliases configured"
}

# Configure starship prompt
configure_starship() {
    print_status "Configuring starship prompt..."

    mkdir -p "$HOME/.config"

    cat > "$HOME/.config/starship.toml" << 'EOF'
# Starship configuration for development
format = """
[](#9A348E)\
$os\
$username\
[](bg:#DA627D fg:#9A348E)\
$directory\
[](fg:#DA627D bg:#FCA17D)\
$git_branch\
$git_status\
[](fg:#FCA17D bg:#86BBD8)\
$nodejs\
$php\
$golang\
$docker_context\
[](fg:#86BBD8 bg:#06969A)\
$time\
[ ](fg:#06969A)\
"""

# Disable the blank line at the start of the prompt
add_newline = false

# You can also replace your username with a neat symbol like   or disable this
# and use the os module below
[username]
show_always = true
style_user = "bg:#9A348E"
style_root = "bg:#9A348E"
format = '[$user ]($style)'
disabled = false

# An alternative to the username module which displays a symbol that
# represents the current operating system
[os]
style = "bg:#9A348E"
disabled = true # Disabled by default

[directory]
style = "bg:#DA627D"
format = "[ $path ]($style)"
truncation_length = 3
truncation_symbol = "…/"

# Here is how you can shorten some long paths by text replacement
# similar to mapped_locations in Oh My Posh:
[directory.substitutions]
"Documents" = "󰈙 "
"Downloads" = " "
"Music" = " "
"Pictures" = " "

[git_branch]
symbol = ""
style = "bg:#FCA17D"
format = '[ $symbol $branch ]($style)'

[git_status]
style = "bg:#FCA17D"
format = '[$all_status$ahead_behind ]($style)'

[nodejs]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[php]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[golang]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol ($version) ]($style)'

[docker_context]
symbol = ""
style = "bg:#86BBD8"
format = '[ $symbol $context ]($style)'

[time]
disabled = false
time_format = "%R" # Hour:Minute Format
style = "bg:#06969A"
format = '[ ♥ $time ]($style)'
EOF

    # Add starship to shell config
    if ! grep -q "starship init" "$HOME/.zshrc"; then
        echo 'eval "$(starship init zsh)"' >> "$HOME/.zshrc"
    fi

    print_success "Starship prompt configured"
}

# Setup better git configuration
configure_git_modern() {
    print_status "Configuring modern git settings..."

    # Delta configuration
    git config --global core.pager "delta"
    git config --global interactive.diffFilter "delta --color-only"
    git config --global delta.navigate true
    git config --global delta.light false
    git config --global delta.side-by-side true
    git config --global merge.conflictstyle diff3
    git config --global diff.colorMoved default

    print_success "Modern git configuration applied"
}

# Main installation function
main() {
    print_status "Starting modern CLI tools installation..."

    install_modern_cli
    install_nerd_fonts
    install_yadm
    setup_modern_aliases
    configure_starship
    configure_git_modern

    print_success "Modern CLI tools installation completed!"
    print_status "Please restart your terminal or run 'source ~/.zshrc' to apply changes"

    echo ""
    print_status "New tools available:"
    echo "  exa     - Modern ls replacement"
    echo "  bat     - Better cat with syntax highlighting"
    echo "  fd      - Fast find alternative"
    echo "  rg      - Fast grep alternative"
    echo "  zoxide  - Smart cd command"
    echo "  yazi    - Terminal file manager"
    echo "  delta   - Better git diff"
    echo "  starship- Beautiful shell prompt"
    echo "  yadm    - Dotfiles manager"
}

# Run main installation
main "$@"
