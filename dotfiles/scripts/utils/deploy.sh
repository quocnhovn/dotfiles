#!/bin/bash

# Deployment Script for VPS
# Automates deployment process using GitHub Actions and Docker

set -e

# Configuration
VPS_IP="${VPS_IP:-your.vps.ip.here}"
VPS_USER="${VPS_USER:-root}"
DEPLOY_PATH="${DEPLOY_PATH:-/var/www}"
DOCKER_COMPOSE_FILE="${DOCKER_COMPOSE_FILE:-docker-compose.prod.yml}"

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

print_status() {
    echo -e "${BLUE}[DEPLOY]${NC} $1"
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
    echo "Deployment Script for VPS"
    echo ""
    echo "Usage: $0 [COMMAND] [OPTIONS]"
    echo ""
    echo "Commands:"
    echo "  deploy [project]    Deploy project to VPS"
    echo "  setup               Initial VPS setup"
    echo "  status              Check deployment status"
    echo "  logs [service]      Show deployment logs"
    echo "  rollback            Rollback to previous version"
    echo "  ssh                 SSH into VPS"
    echo "  backup              Create backup"
    echo "  restore [backup]    Restore from backup"
    echo ""
    echo "Environment Variables:"
    echo "  VPS_IP              VPS IP address"
    echo "  VPS_USER            VPS username (default: root)"
    echo "  DEPLOY_PATH         Deployment path (default: /var/www)"
    echo ""
}

# Check SSH connection
check_ssh() {
    print_status "Checking SSH connection to $VPS_IP..."
    if ssh -o ConnectTimeout=5 -o BatchMode=yes "$VPS_USER@$VPS_IP" exit 2>/dev/null; then
        print_success "SSH connection successful"
        return 0
    else
        print_error "SSH connection failed. Please check your SSH keys and VPS configuration."
        return 1
    fi
}

# Initial VPS setup
setup_vps() {
    print_status "Setting up VPS for deployment..."

    if ! check_ssh; then
        return 1
    fi

    print_status "Installing required packages on VPS..."
    ssh "$VPS_USER@$VPS_IP" << 'EOF'
        # Update system
        apt update && apt upgrade -y

        # Install Docker
        curl -fsSL https://get.docker.com -o get-docker.sh
        sh get-docker.sh
        usermod -aG docker $USER

        # Install Docker Compose
        curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        chmod +x /usr/local/bin/docker-compose

        # Install other utilities
        apt install -y git nginx certbot python3-certbot-nginx htop tree

        # Create deployment directory
        mkdir -p /var/www
        mkdir -p /var/backups

        # Setup firewall
        ufw allow ssh
        ufw allow http
        ufw allow https
        ufw --force enable
EOF

    print_success "VPS setup completed"
}

# Deploy project
deploy_project() {
    local project_name="$1"

    if [ -z "$project_name" ]; then
        project_name=$(basename "$(pwd)")
    fi

    print_status "Deploying project: $project_name"

    if ! check_ssh; then
        return 1
    fi

    # Create deployment script
    cat > /tmp/deploy-script.sh << EOF
#!/bin/bash
set -e

PROJECT_NAME="$project_name"
DEPLOY_DIR="$DEPLOY_PATH/\$PROJECT_NAME"
BACKUP_DIR="/var/backups/\$PROJECT_NAME-\$(date +%Y%m%d-%H%M%S)"

echo "Starting deployment of \$PROJECT_NAME..."

# Create backup if project exists
if [ -d "\$DEPLOY_DIR" ]; then
    echo "Creating backup..."
    cp -r "\$DEPLOY_DIR" "\$BACKUP_DIR"
fi

# Create project directory
mkdir -p "\$DEPLOY_DIR"
cd "\$DEPLOY_DIR"

# Pull latest code (this would typically be done by GitHub Actions)
if [ -d ".git" ]; then
    git pull origin main
else
    echo "Git repository not found. Please ensure code is deployed via GitHub Actions."
fi

# Run deployment commands
if [ -f "$DOCKER_COMPOSE_FILE" ]; then
    echo "Starting Docker containers..."
    docker-compose -f "$DOCKER_COMPOSE_FILE" down
    docker-compose -f "$DOCKER_COMPOSE_FILE" pull
    docker-compose -f "$DOCKER_COMPOSE_FILE" up -d
elif [ -f "docker-compose.yml" ]; then
    echo "Starting Docker containers..."
    docker-compose down
    docker-compose pull
    docker-compose up -d
fi

# Health check
sleep 10
if docker-compose ps | grep -q "Up"; then
    echo "Deployment successful!"
else
    echo "Deployment failed! Rolling back..."
    if [ -d "\$BACKUP_DIR" ]; then
        rm -rf "\$DEPLOY_DIR"
        mv "\$BACKUP_DIR" "\$DEPLOY_DIR"
        cd "\$DEPLOY_DIR"
        docker-compose up -d
    fi
    exit 1
fi

echo "Deployment completed successfully!"
EOF

    # Copy and execute deployment script
    scp /tmp/deploy-script.sh "$VPS_USER@$VPS_IP:/tmp/"
    ssh "$VPS_USER@$VPS_IP" "chmod +x /tmp/deploy-script.sh && /tmp/deploy-script.sh"

    print_success "Deployment completed"
    rm /tmp/deploy-script.sh
}

# Check deployment status
check_status() {
    print_status "Checking deployment status..."

    if ! check_ssh; then
        return 1
    fi

    ssh "$VPS_USER@$VPS_IP" << 'EOF'
        echo "=== Docker Container Status ==="
        docker ps

        echo ""
        echo "=== System Resources ==="
        free -h
        df -h

        echo ""
        echo "=== Recent Deployments ==="
        ls -la /var/backups/ | tail -5
EOF
}

# Show logs
show_logs() {
    local service="$1"

    print_status "Showing logs..."

    if ! check_ssh; then
        return 1
    fi

    if [ -n "$service" ]; then
        ssh "$VPS_USER@$VPS_IP" "cd $DEPLOY_PATH && docker-compose logs -f $service"
    else
        ssh "$VPS_USER@$VPS_IP" "cd $DEPLOY_PATH && docker-compose logs -f"
    fi
}

# Rollback deployment
rollback() {
    print_status "Rolling back deployment..."

    if ! check_ssh; then
        return 1
    fi

    ssh "$VPS_USER@$VPS_IP" << EOF
        LATEST_BACKUP=\$(ls -t /var/backups/ | head -1)

        if [ -z "\$LATEST_BACKUP" ]; then
            echo "No backup found!"
            exit 1
        fi

        echo "Rolling back to: \$LATEST_BACKUP"

        # Stop current containers
        cd $DEPLOY_PATH
        docker-compose down

        # Restore backup
        rm -rf $DEPLOY_PATH/current
        cp -r "/var/backups/\$LATEST_BACKUP" "$DEPLOY_PATH/current"

        # Start containers
        cd $DEPLOY_PATH/current
        docker-compose up -d

        echo "Rollback completed!"
EOF

    print_success "Rollback completed"
}

# SSH into VPS
ssh_vps() {
    print_status "Connecting to VPS..."
    ssh "$VPS_USER@$VPS_IP"
}

# Create backup
create_backup() {
    print_status "Creating backup..."

    if ! check_ssh; then
        return 1
    fi

    ssh "$VPS_USER@$VPS_IP" << 'EOF'
        BACKUP_NAME="manual-backup-$(date +%Y%m%d-%H%M%S)"

        # Create database backup
        docker-compose exec -T mysql mysqldump -u root -p"$MYSQL_ROOT_PASSWORD" --all-databases > "/var/backups/$BACKUP_NAME-database.sql"

        # Create files backup
        tar -czf "/var/backups/$BACKUP_NAME-files.tar.gz" -C /var/www .

        echo "Backup created: $BACKUP_NAME"
EOF

    print_success "Backup created"
}

# Generate GitHub Actions workflow
generate_github_actions() {
    print_status "Generating GitHub Actions workflow..."

    mkdir -p .github/workflows

    cat > .github/workflows/deploy.yml << EOF
name: Deploy to VPS

on:
  push:
    branches: [ main ]

jobs:
  deploy:
    runs-on: ubuntu-latest

    steps:
    - uses: actions/checkout@v2

    - name: Setup SSH
      uses: webfactory/ssh-agent@v0.5.3
      with:
        ssh-private-key: \${{ secrets.SSH_PRIVATE_KEY }}

    - name: Deploy to VPS
      run: |
        ssh -o StrictHostKeyChecking=no $VPS_USER@$VPS_IP << 'EOF'
          cd $DEPLOY_PATH/\$(basename \$GITHUB_REPOSITORY)
          git pull origin main
          docker-compose down
          docker-compose build
          docker-compose up -d
        EOF
EOF

    print_success "GitHub Actions workflow created at .github/workflows/deploy.yml"
    print_warning "Don't forget to add SSH_PRIVATE_KEY to your GitHub repository secrets!"
}

# Main command handler
case "${1:-help}" in
    "deploy")
        deploy_project "$2"
        ;;
    "setup")
        setup_vps
        ;;
    "status")
        check_status
        ;;
    "logs")
        show_logs "$2"
        ;;
    "rollback")
        rollback
        ;;
    "ssh")
        ssh_vps
        ;;
    "backup")
        create_backup
        ;;
    "github-actions")
        generate_github_actions
        ;;
    "help"|*)
        show_help
        ;;
esac
