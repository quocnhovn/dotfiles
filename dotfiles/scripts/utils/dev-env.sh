#!/bin/bash

# Development Environment Manager
# Quick setup and management of development environments

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[DEV]${NC} $1"
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

show_help() {
    echo "Development Environment Manager"
    echo ""
    echo "Usage: $0 [COMMAND] [PROJECT_NAME]"
    echo ""
    echo "Commands:"
    echo "  new [type] [name]   Create new project (laravel|vue|go|php)"
    echo "  start [name]        Start development environment"
    echo "  stop [name]         Stop development environment"
    echo "  open [name]         Open project in editor"
    echo "  test [name]         Run tests for project"
    echo "  build [name]        Build project"
    echo "  clean [name]        Clean project cache/build files"
    echo "  db [name]           Database operations"
    echo "  list                List all projects"
    echo "  status              Show status of all environments"
    echo ""
}

# Get projects directory
PROJECTS_DIR="$HOME/Development"

# Create new project
create_project() {
    local project_type="$1"
    local project_name="$2"

    if [ -z "$project_type" ] || [ -z "$project_name" ]; then
        print_error "Usage: new [type] [name]"
        echo "Types: laravel, vue, go, php"
        return 1
    fi

    local project_path="$PROJECTS_DIR/$project_name"

    if [ -d "$project_path" ]; then
        print_error "Project $project_name already exists"
        return 1
    fi

    print_status "Creating $project_type project: $project_name"

    case "$project_type" in
        "laravel")
            cd "$PROJECTS_DIR"
            composer create-project laravel/laravel "$project_name"
            cd "$project_name"

            # Setup Laravel environment
            cp .env.example .env
            php artisan key:generate

            # Create docker-compose.yml
            cat > docker-compose.yml << 'EOF'
version: '3.8'
services:
  app:
    build: .
    ports:
      - "8000:8000"
    volumes:
      - .:/var/www/html
    depends_on:
      - mysql
      - redis

  mysql:
    image: mysql:8.0
    environment:
      MYSQL_DATABASE: laravel
      MYSQL_USER: laravel
      MYSQL_PASSWORD: secret
      MYSQL_ROOT_PASSWORD: secret
    ports:
      - "3306:3306"
    volumes:
      - mysql_data:/var/lib/mysql

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"

volumes:
  mysql_data:
EOF

            # Update .env for Docker
            sed -i 's/DB_HOST=127.0.0.1/DB_HOST=mysql/' .env
            sed -i 's/REDIS_HOST=127.0.0.1/REDIS_HOST=redis/' .env
            ;;

        "vue")
            cd "$PROJECTS_DIR"
            npm create vue@latest "$project_name"
            cd "$project_name"
            npm install

            # Add development scripts
            npm install -D @vitejs/plugin-vue
            npm install -D tailwindcss postcss autoprefixer
            npx tailwindcss init -p
            ;;

        "go")
            mkdir -p "$project_path"
            cd "$project_path"
            go mod init "$project_name"

            # Create main.go
            cat > main.go << 'EOF'
package main

import (
    "fmt"
    "net/http"
    "log"
)

func main() {
    http.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
        fmt.Fprintf(w, "Hello, World!")
    })

    fmt.Println("Server starting on :8080")
    log.Fatal(http.ListenAndServe(":8080", nil))
}
EOF

            # Create Dockerfile
            cat > Dockerfile << 'EOF'
FROM golang:1.21-alpine AS builder
WORKDIR /app
COPY go.mod go.sum ./
RUN go mod download
COPY . .
RUN go build -o main .

FROM alpine:latest
RUN apk --no-cache add ca-certificates
WORKDIR /root/
COPY --from=builder /app/main .
EXPOSE 8080
CMD ["./main"]
EOF
            ;;

        "php")
            mkdir -p "$project_path"
            cd "$project_path"

            # Initialize composer
            composer init --no-interaction --name="$project_name/$project_name"

            # Create basic structure
            mkdir -p src public tests

            # Create index.php
            cat > public/index.php << 'EOF'
<?php
require_once __DIR__ . '/../vendor/autoload.php';

echo "Hello, World!";
EOF

            # Add development dependencies
            composer require --dev phpunit/phpunit
            ;;

        *)
            print_error "Unknown project type: $project_type"
            return 1
            ;;
    esac

    # Initialize git
    git init
    git add .
    git commit -m "Initial commit"

    print_success "Project $project_name created successfully"
    print_status "Project location: $project_path"
}

# Start development environment
start_project() {
    local project_name="$1"

    if [ -z "$project_name" ]; then
        print_error "Please specify project name"
        return 1
    fi

    local project_path="$PROJECTS_DIR/$project_name"

    if [ ! -d "$project_path" ]; then
        print_error "Project $project_name not found"
        return 1
    fi

    cd "$project_path"

    print_status "Starting development environment for $project_name"

    # Start based on project type
    if [ -f "docker-compose.yml" ]; then
        docker-compose up -d
    elif [ -f "artisan" ]; then
        php artisan serve &
    elif [ -f "package.json" ]; then
        npm run dev &
    elif [ -f "go.mod" ]; then
        go run main.go &
    else
        print_warning "No known development server configuration found"
    fi

    print_success "Development environment started"
}

# Stop development environment
stop_project() {
    local project_name="$1"

    if [ -z "$project_name" ]; then
        print_error "Please specify project name"
        return 1
    fi

    local project_path="$PROJECTS_DIR/$project_name"

    if [ ! -d "$project_path" ]; then
        print_error "Project $project_name not found"
        return 1
    fi

    cd "$project_path"

    print_status "Stopping development environment for $project_name"

    if [ -f "docker-compose.yml" ]; then
        docker-compose down
    else
        # Kill processes by port (basic implementation)
        pkill -f "php artisan serve" || true
        pkill -f "npm run dev" || true
        pkill -f "go run" || true
    fi

    print_success "Development environment stopped"
}

# Open project in editor
open_project() {
    local project_name="$1"

    if [ -z "$project_name" ]; then
        print_error "Please specify project name"
        return 1
    fi

    local project_path="$PROJECTS_DIR/$project_name"

    if [ ! -d "$project_path" ]; then
        print_error "Project $project_name not found"
        return 1
    fi

    print_status "Opening $project_name in editor"

    # Open in VS Code and Neovim
    code "$project_path" &

    # Start tmux session
    tmux new-session -d -s "$project_name" -c "$project_path"
    tmux attach-session -t "$project_name"
}

# Run tests
test_project() {
    local project_name="$1"

    if [ -z "$project_name" ]; then
        print_error "Please specify project name"
        return 1
    fi

    local project_path="$PROJECTS_DIR/$project_name"

    if [ ! -d "$project_path" ]; then
        print_error "Project $project_name not found"
        return 1
    fi

    cd "$project_path"

    print_status "Running tests for $project_name"

    if [ -f "artisan" ]; then
        php artisan test
    elif [ -f "package.json" ]; then
        npm test
    elif [ -f "go.mod" ]; then
        go test ./...
    elif [ -f "phpunit.xml" ]; then
        ./vendor/bin/phpunit
    else
        print_warning "No test configuration found"
    fi
}

# List all projects
list_projects() {
    print_status "Available projects:"

    if [ ! -d "$PROJECTS_DIR" ]; then
        print_warning "Projects directory not found: $PROJECTS_DIR"
        return 1
    fi

    for dir in "$PROJECTS_DIR"/*; do
        if [ -d "$dir" ]; then
            local project_name=$(basename "$dir")
            local project_type="Unknown"

            if [ -f "$dir/artisan" ]; then
                project_type="Laravel"
            elif [ -f "$dir/package.json" ]; then
                project_type="Node.js/Vue"
            elif [ -f "$dir/go.mod" ]; then
                project_type="Go"
            elif [ -f "$dir/composer.json" ]; then
                project_type="PHP"
            fi

            echo "  📁 $project_name ($project_type)"
        fi
    done
}

# Show environment status
show_status() {
    print_status "Development environment status:"

    echo ""
    echo "🐳 Docker containers:"
    docker ps --format "table {{.Names}}\t{{.Image}}\t{{.Status}}\t{{.Ports}}"

    echo ""
    echo "🔧 Development servers:"
    netstat -tuln | grep -E ":80[0-9][0-9]|:30[0-9][0-9]|:8080" || echo "  No development servers running"

    echo ""
    echo "💾 Database services:"
    netstat -tuln | grep -E ":3306|:5432|:27017" || echo "  No database services running"
}

# Main command handler
case "${1:-help}" in
    "new")
        create_project "$2" "$3"
        ;;
    "start")
        start_project "$2"
        ;;
    "stop")
        stop_project "$2"
        ;;
    "open")
        open_project "$2"
        ;;
    "test")
        test_project "$2"
        ;;
    "list")
        list_projects
        ;;
    "status")
        show_status
        ;;
    "help"|*)
        show_help
        ;;
esac
