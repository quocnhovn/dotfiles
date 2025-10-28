# ZSH Configuration for Development
# Optimized for fullstack development workflow

# Path to your oh-my-zsh installation
export ZSH="$HOME/.oh-my-zsh"

# Theme
ZSH_THEME="agnoster"

# Plugins
plugins=(
  git
  docker
  docker-compose
  npm
  node
  composer
  laravel
  golang
  zsh-autosuggestions
  zsh-syntax-highlighting
  history-substring-search
  web-search
)

source $ZSH/oh-my-zsh.sh

# User configuration

# Language environment
export LANG=en_US.UTF-8

# Preferred editor
export EDITOR='nvim'
export VISUAL='nvim'

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Path configuration
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.composer/vendor/bin:$PATH"
export PATH="/usr/local/go/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.config/composer/vendor/bin:$PATH"

# Go environment
export GOPATH="$HOME/go"
export GOROOT="/usr/local/go"

# Node Version Manager
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# PHP Configuration
export PHP_CS_FIXER_IGNORE_ENV=1

# History configuration
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS
setopt HIST_IGNORE_SPACE

# General aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias cls='clear'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Editor aliases
alias vim='nvim'
alias vi='nvim'
alias code='code .'

# Git aliases
alias g='git'
alias ga='git add'
alias gaa='git add .'
alias gb='git branch'
alias gc='git commit'
alias gcm='git commit -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gf='git fetch'
alias gl='git log --oneline'
alias gp='git push'
alias gpl='git pull'
alias gs='git status'
alias gst='git stash'
alias gstp='git stash pop'
alias gm='git merge'
alias gr='git rebase'
alias gri='git rebase -i'
alias grh='git reset --hard'
alias grs='git reset --soft'
alias glg='git log --graph --pretty=format:"%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset" --abbrev-commit'

# Docker aliases
alias d='docker'
alias dc='docker-compose'
alias dcup='docker-compose up -d'
alias dcdown='docker-compose down'
alias dcps='docker-compose ps'
alias dclogs='docker-compose logs -f'
alias dcexec='docker-compose exec'
alias dprune='docker system prune -a'

# Laravel aliases
alias artisan='php artisan'
alias art='php artisan'
alias migrate='php artisan migrate'
alias seed='php artisan db:seed'
alias serve='php artisan serve'
alias tinker='php artisan tinker'
alias route='php artisan route:list'
alias make='php artisan make:'
alias fresh='php artisan migrate:fresh --seed'

# PHP aliases
alias phpunit='./vendor/bin/phpunit'
alias pest='./vendor/bin/pest'
alias pint='./vendor/bin/pint'
alias composer-install='composer install --no-dev --optimize-autoloader'

# Node/NPM aliases
alias ni='npm install'
alias nid='npm install --save-dev'
alias nig='npm install -g'
alias nr='npm run'
alias nrd='npm run dev'
alias nrb='npm run build'
alias nrt='npm run test'
alias nrs='npm start'
alias npx='npx'

# Go aliases
alias gob='go build'
alias gor='go run'
alias got='go test'
alias gom='go mod'
alias gomi='go mod init'
alias gomt='go mod tidy'
alias gof='go fmt'

# System aliases
alias update='sudo apt update && sudo apt upgrade'
alias install='sudo apt install'
alias search='apt search'
alias info='apt info'
alias battery='~/dotfiles/scripts/utils/battery-status.sh'
alias thermal='~/dotfiles/scripts/utils/thermal-status.sh'
alias power='~/dotfiles/scripts/utils/power-mode.sh'

# Modern CLI aliases (will be auto-configured by setup-modern-cli.sh)
# Placeholder for dynamic aliases

# Development aliases
alias dev='tmux new-session -s dev || tmux attach-session -t dev'
alias work='cd ~/Development && ll'
alias projects='cd ~/Development && ll'

# Quick navigation
alias dotfiles='cd ~/dotfiles'
alias config='cd ~/.config'
alias scripts='cd ~/dotfiles/scripts'

# Network aliases
alias myip='curl ifconfig.me'
alias ports='netstat -tulanp'
alias listening='netstat -tuln'

# File operations
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'
alias mkdir='mkdir -pv'
alias df='df -h'
alias du='du -h'
alias free='free -h'

# Process management
alias ps='ps auxf'
alias psg='ps aux | grep -v grep | grep -i -e VSZ -e'
alias top='htop'

# Archive operations
alias tar='tar -xzvf'
alias untar='tar -xzvf'
alias zip='zip -r'

# Web development shortcuts
alias server='python3 -m http.server 8000'
alias phpserver='php -S localhost:8000'

# Database shortcuts (when using docker)
alias mysql-docker='docker exec -it mysql mysql -u root -p'
alias postgres-docker='docker exec -it postgres psql -U postgres'

# Functions
function mkcd() {
    mkdir -p "$1" && cd "$1"
}

function extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

function clone() {
    git clone "$1" && cd "$(basename "$1" .git)"
}

function commit() {
    git add . && git commit -m "$1" && git push
}

function newproject() {
    if [ "$1" = "laravel" ]; then
        composer create-project laravel/laravel "$2"
        cd "$2"
    elif [ "$1" = "vue" ]; then
        npm create vue@latest "$2"
        cd "$2"
        npm install
    elif [ "$1" = "go" ]; then
        mkdir "$2" && cd "$2"
        go mod init "$2"
        echo 'package main\n\nimport "fmt"\n\nfunc main() {\n    fmt.Println("Hello, World!")\n}' > main.go
    else
        echo "Usage: newproject [laravel|vue|go] project_name"
    fi
}

function find-in-files() {
    grep -r "$1" . --exclude-dir=node_modules --exclude-dir=vendor --exclude-dir=.git
}

function weather() {
    curl "wttr.in/$1"
}

# Load fzf
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Custom prompt (if not using oh-my-zsh theme)
# autoload -U colors && colors
# PROMPT="%{$fg[cyan]%}%n@%m %{$fg[green]%}%~ %{$fg[yellow]%}$(git_prompt_info)%{$reset_color%}$ "

# Auto-start tmux if not already in tmux
if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  tmux attach-session -t default || tmux new-session -s default
fi

# Load company/project specific configs
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Custom welcome message
echo "🚀 Development environment loaded!"
echo "📁 Use 'work' to go to development directory"
echo "🔧 Use 'dev' to start development tmux session"
echo "🔋 Use 'battery' to check battery status"
