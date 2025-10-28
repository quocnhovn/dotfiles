#!/bin/bash

# Runtime Environment Setup Script
# Install and configure PHP, Go, Node.js and related tools

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[RUNTIME]${NC} $1"
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

# PHP Setup
setup_php() {
    print_status "Setting up PHP environment..."

    # Install PHP and common extensions
    sudo apt install -y \
        php8.2 \
        php8.2-cli \
        php8.2-fpm \
        php8.2-mysql \
        php8.2-pgsql \
        php8.2-sqlite3 \
        php8.2-redis \
        php8.2-curl \
        php8.2-gd \
        php8.2-mbstring \
        php8.2-xml \
        php8.2-zip \
        php8.2-bcmath \
        php8.2-intl \
        php8.2-soap \
        php8.2-xsl \
        php8.2-oauth \
        php8.2-apcu \
        php8.2-uuid \
        php8.2-imagick \
        php8.2-dev

    # Install Composer
    if ! command -v composer &> /dev/null; then
        print_status "Installing Composer..."
        curl -sS https://getcomposer.org/installer | php
        sudo mv composer.phar /usr/local/bin/composer
        sudo chmod +x /usr/local/bin/composer
    fi

    # Configure PHP
    print_status "Configuring PHP..."

    # Get PHP version for config path
    PHP_VERSION=$(php -r "echo PHP_MAJOR_VERSION.'.'.PHP_MINOR_VERSION;")
    PHP_INI="/etc/php/$PHP_VERSION/cli/php.ini"

    # Backup original php.ini
    sudo cp "$PHP_INI" "$PHP_INI.backup"

    # Configure PHP settings for development
    sudo tee -a "$PHP_INI" > /dev/null << 'EOF'

; Development Settings
memory_limit = 512M
max_execution_time = 300
upload_max_filesize = 100M
post_max_size = 100M
max_file_uploads = 50
error_reporting = E_ALL
display_errors = On
display_startup_errors = On
log_errors = On
error_log = /var/log/php_errors.log

; OPcache settings
opcache.enable=1
opcache.enable_cli=1
opcache.memory_consumption=256
opcache.interned_strings_buffer=16
opcache.max_accelerated_files=10000
opcache.revalidate_freq=2
opcache.fast_shutdown=1

; APCu settings
apc.enabled=1
apc.shm_size=64M
apc.ttl=7200
apc.enable_cli=1
EOF

    # Install global Composer packages
    print_status "Installing global Composer packages..."
    composer global require \
        laravel/installer \
        laravel/valet \
        phpunit/phpunit \
        squizlabs/php_codesniffer \
        friendsofphp/php-cs-fixer \
        psy/psysh \
        phan/phan

    # Install Laravel Pint
    composer global require laravel/pint

    print_success "PHP environment setup completed"
}

# Go Setup
setup_go() {
    print_status "Setting up Go environment..."

    # Install Go
    GO_VERSION="1.21.3"
    if ! command -v go &> /dev/null; then
        print_status "Installing Go $GO_VERSION..."
        wget "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" -O /tmp/go.tar.gz
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf /tmp/go.tar.gz
        rm /tmp/go.tar.gz
    fi

    # Setup Go environment
    export GOROOT="/usr/local/go"
    export GOPATH="$HOME/go"
    export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"

    # Create Go workspace
    mkdir -p "$HOME/go/"{bin,src,pkg}

    # Install useful Go tools
    print_status "Installing Go tools..."
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
    go install honnef.co/go/tools/cmd/staticcheck@latest
    go install golang.org/x/tools/cmd/goimports@latest
    go install github.com/fatih/gomodifytags@latest
    go install github.com/josharian/impl@latest
    go install github.com/air-verse/air@latest
    go install github.com/swaggo/swag/cmd/swag@latest

    print_success "Go environment setup completed"
}

# Node.js Setup
setup_nodejs() {
    print_status "Setting up Node.js environment..."

    # Install Node Version Manager (nvm)
    if [ ! -d "$HOME/.nvm" ]; then
        print_status "Installing Node Version Manager (nvm)..."
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    fi

    # Source nvm
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    # Install latest LTS Node.js
    print_status "Installing Node.js LTS..."
    nvm install --lts
    nvm use --lts
    nvm alias default lts/*

    # Install global packages
    print_status "Installing global npm packages..."
    npm install -g \
        @vue/cli \
        @vue/cli-service-global \
        create-vue \
        @vitejs/create-app \
        typescript \
        ts-node \
        nodemon \
        pm2 \
        serve \
        http-server \
        live-server \
        eslint \
        prettier \
        @prettier/plugin-php \
        sass \
        less \
        stylus \
        postcss-cli \
        autoprefixer \
        tailwindcss \
        concurrently \
        cross-env \
        rimraf \
        npm-check-updates \
        yarn \
        pnpm

    # Install Bun (alternative JavaScript runtime)
    if ! command -v bun &> /dev/null; then
        print_status "Installing Bun..."
        curl -fsSL https://bun.sh/install | bash
    fi

    print_success "Node.js environment setup completed"
}

# Database Setup
setup_databases() {
    print_status "Setting up database tools..."

    # Install database clients
    sudo apt install -y \
        mysql-client \
        postgresql-client \
        sqlite3 \
        redis-tools

    # Install database GUI tools
    if ! command -v dbeaver &> /dev/null; then
        print_status "Installing DBeaver..."
        wget -O /tmp/dbeaver.deb "https://dbeaver.io/files/dbeaver-ce_latest_amd64.deb"
        sudo dpkg -i /tmp/dbeaver.deb || sudo apt install -f
        rm /tmp/dbeaver.deb
    fi

    print_success "Database tools setup completed"
}

# Development Tools Setup
setup_dev_tools() {
    print_status "Setting up development tools..."

    # Install system tools
    sudo apt install -y \
        curl \
        wget \
        git \
        vim \
        neovim \
        tmux \
        htop \
        tree \
        jq \
        httpie \
        git-flow \
        meld \
        filezilla \
        postman

    # Install VS Code (if not already installed)
    if ! command -v code &> /dev/null; then
        print_status "Installing Visual Studio Code..."
        wget -qO- https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > packages.microsoft.gpg
        sudo install -o root -g root -m 644 packages.microsoft.gpg /etc/apt/trusted.gpg.d/
        sudo sh -c 'echo "deb [arch=amd64,arm64,armhf signed-by=/etc/apt/trusted.gpg.d/packages.microsoft.gpg] https://packages.microsoft.com/repos/code stable main" > /etc/apt/sources.list.d/vscode.list'
        sudo apt update
        sudo apt install -y code
    fi

    # Install Docker (if not already installed)
    if ! command -v docker &> /dev/null; then
        print_status "Installing Docker..."
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        sudo usermod -aG docker $USER
        rm get-docker.sh
    fi

    # Install Docker Compose
    if ! command -v docker-compose &> /dev/null; then
        print_status "Installing Docker Compose..."
        sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
    fi

    # Install Insomnia REST Client
    if ! command -v insomnia &> /dev/null; then
        print_status "Installing Insomnia..."
        echo "deb [trusted=yes arch=amd64] https://download.konghq.com/insomnia-ubuntu/ default all" | sudo tee -a /etc/apt/sources.list.d/insomnia.list
        sudo apt update
        sudo apt install -y insomnia
    fi

    print_success "Development tools setup completed"
}

# Setup Shell Environment
setup_shell() {
    print_status "Setting up shell environment..."

    # Install Oh My Zsh (if not already installed)
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        print_status "Installing Oh My Zsh..."
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Install useful command-line tools
    sudo apt install -y \
        fzf \
        ripgrep \
        fd-find \
        bat \
        exa \
        zoxide \
        starship

    # Install modern CLI tools via cargo (if Rust is available)
    if command -v cargo &> /dev/null; then
        cargo install \
            bat \
            exa \
            ripgrep \
            fd-find \
            zoxide \
            starship
    fi

    print_success "Shell environment setup completed"
}

# Create development environment shortcuts
create_shortcuts() {
    print_status "Creating development shortcuts..."

    # Create desktop shortcuts for common development tasks
    mkdir -p "$HOME/.local/share/applications"

    # Laravel development shortcut
    cat > "$HOME/.local/share/applications/laravel-dev.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Laravel Development
Comment=Start Laravel development environment
Exec=bash -c 'cd ~/Development && gnome-terminal -- bash -c "php artisan serve; exec bash"'
Icon=utilities-terminal
Terminal=false
Categories=Development;
EOF

    # Vue development shortcut
    cat > "$HOME/.local/share/applications/vue-dev.desktop" << 'EOF'
[Desktop Entry]
Version=1.0
Type=Application
Name=Vue Development
Comment=Start Vue development server
Exec=bash -c 'cd ~/Development && gnome-terminal -- bash -c "npm run dev; exec bash"'
Icon=utilities-terminal
Terminal=false
Categories=Development;
EOF

    chmod +x "$HOME/.local/share/applications/"*.desktop

    print_success "Development shortcuts created"
}

# Main setup function
main() {
    print_status "Starting runtime environment setup..."

    # Update system first
    print_status "Updating system packages..."
    sudo apt update && sudo apt upgrade -y

    # Setup each environment
    setup_php
    setup_go
    setup_nodejs
    setup_databases
    setup_dev_tools
    setup_shell
    create_shortcuts

    # Final configuration
    print_status "Finalizing configuration..."

    # Add paths to shell configuration
    cat >> "$HOME/.zshrc" << 'EOF'

# Runtime environment paths
export GOROOT="/usr/local/go"
export GOPATH="$HOME/go"
export PATH="$GOROOT/bin:$GOPATH/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
EOF

    print_success "Runtime environment setup completed!"
    print_status "Please restart your terminal or run 'source ~/.zshrc' to apply changes"

    echo ""
    print_status "Installed versions:"
    echo "  PHP: $(php --version | head -1)"
    echo "  Composer: $(composer --version)"
    echo "  Go: $(go version)"
    echo "  Node.js: $(node --version)"
    echo "  NPM: $(npm --version)"
    echo "  Docker: $(docker --version)"
    echo "  Docker Compose: $(docker-compose --version)"
}

# Run main setup
main "$@"
