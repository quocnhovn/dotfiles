#!/bin/bash

# Docker Development Utilities
# Collection of useful Docker commands for development

set -e

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[DOCKER]${NC} $1"
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

# Function to display help
show_help() {
    echo "Docker Development Utilities"
    echo ""
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  up              Start all containers"
    echo "  down            Stop all containers"
    echo "  restart         Restart all containers"
    echo "  build           Rebuild all containers"
    echo "  logs [service]  Show logs (optionally for specific service)"
    echo "  shell [service] Open shell in container"
    echo "  clean           Clean up unused Docker resources"
    echo "  reset           Stop all containers and remove volumes"
    echo "  status          Show status of all containers"
    echo "  laravel         Quick Laravel development setup"
    echo "  vue             Quick Vue.js development setup"
    echo "  go              Quick Go development setup"
    echo "  php             Run PHP commands in container"
    echo "  npm             Run NPM commands in container"
    echo "  composer        Run Composer commands in container"
    echo ""
}

# Check if docker-compose exists
if ! command -v docker-compose &> /dev/null; then
    print_error "docker-compose is not installed"
    exit 1
fi

# Main command handler
case "${1:-help}" in
    "up")
        print_status "Starting Docker containers..."
        docker-compose up -d
        print_success "Containers started"
        ;;

    "down")
        print_status "Stopping Docker containers..."
        docker-compose down
        print_success "Containers stopped"
        ;;

    "restart")
        print_status "Restarting Docker containers..."
        docker-compose restart
        print_success "Containers restarted"
        ;;

    "build")
        print_status "Rebuilding Docker containers..."
        docker-compose build --no-cache
        docker-compose up -d
        print_success "Containers rebuilt and started"
        ;;

    "logs")
        if [ -n "$2" ]; then
            print_status "Showing logs for service: $2"
            docker-compose logs -f "$2"
        else
            print_status "Showing logs for all services"
            docker-compose logs -f
        fi
        ;;

    "shell")
        if [ -n "$2" ]; then
            print_status "Opening shell in service: $2"
            docker-compose exec "$2" /bin/bash
        else
            print_error "Please specify a service name"
            echo "Available services:"
            docker-compose ps --services
        fi
        ;;

    "clean")
        print_status "Cleaning up unused Docker resources..."
        docker system prune -af
        docker volume prune -f
        print_success "Docker cleanup completed"
        ;;

    "reset")
        print_warning "This will stop all containers and remove volumes!"
        read -p "Are you sure? (y/N): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            print_status "Resetting Docker environment..."
            docker-compose down -v
            docker system prune -af
            print_success "Docker environment reset"
        else
            print_status "Reset cancelled"
        fi
        ;;

    "status")
        print_status "Docker container status:"
        docker-compose ps
        echo ""
        print_status "Docker system info:"
        docker system df
        ;;

    "laravel")
        print_status "Setting up Laravel development environment..."
        cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8000:8000"
    volumes:
      - .:/var/www/html
    environment:
      - DB_HOST=mysql
      - DB_DATABASE=laravel
      - DB_USERNAME=laravel
      - DB_PASSWORD=secret
    depends_on:
      - mysql
      - redis

  mysql:
    image: mysql:8.0
    ports:
      - "3306:3306"
    environment:
      MYSQL_DATABASE: laravel
      MYSQL_USER: laravel
      MYSQL_PASSWORD: secret
      MYSQL_ROOT_PASSWORD: secret
    volumes:
      - mysql_data:/var/lib/mysql

  redis:
    image: redis:alpine
    ports:
      - "6379:6379"

  mailhog:
    image: mailhog/mailhog
    ports:
      - "1025:1025"
      - "8025:8025"

volumes:
  mysql_data:
EOF

        cat > Dockerfile << 'EOF'
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    zip \
    unzip

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . .

# Install dependencies
RUN composer install

# Expose port
EXPOSE 8000

# Start PHP development server
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
EOF
        print_success "Laravel Docker setup created"
        ;;

    "vue")
        print_status "Setting up Vue.js development environment..."
        cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "3000:3000"
      - "24678:24678" # Vite HMR
    volumes:
      - .:/app
      - /app/node_modules
    environment:
      - CHOKIDAR_USEPOLLING=true

volumes:
  node_modules:
EOF

        cat > Dockerfile << 'EOF'
FROM node:18-alpine

WORKDIR /app

COPY package*.json ./
RUN npm ci

COPY . .

EXPOSE 3000 24678

CMD ["npm", "run", "dev", "--", "--host", "0.0.0.0"]
EOF
        print_success "Vue.js Docker setup created"
        ;;

    "go")
        print_status "Setting up Go development environment..."
        cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile
    ports:
      - "8080:8080"
    volumes:
      - .:/app
    working_dir: /app
    command: go run main.go

  postgres:
    image: postgres:15
    environment:
      POSTGRES_DB: goapp
      POSTGRES_USER: user
      POSTGRES_PASSWORD: password
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data

volumes:
  postgres_data:
EOF

        cat > Dockerfile << 'EOF'
FROM golang:1.21-alpine

WORKDIR /app

RUN apk add --no-cache git

COPY go.mod go.sum ./
RUN go mod download

COPY . .

EXPOSE 8080

CMD ["go", "run", "main.go"]
EOF
        print_success "Go Docker setup created"
        ;;

    "php")
        shift
        print_status "Running PHP command: $*"
        docker-compose exec app php "$@"
        ;;

    "npm")
        shift
        print_status "Running NPM command: $*"
        docker-compose exec app npm "$@"
        ;;

    "composer")
        shift
        print_status "Running Composer command: $*"
        docker-compose exec app composer "$@"
        ;;

    "help"|*)
        show_help
        ;;
esac
