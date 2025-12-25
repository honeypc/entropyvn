#!/bin/bash

# Development Environment Setup Script
# This script sets up the development environment for the entropyvn project

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_step() {
    echo -e "${BLUE}==>${NC} $1"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

# Check if Docker is installed
if ! command -v docker &> /dev/null; then
    print_error "Docker is not installed. Please install Docker first."
    exit 1
fi

# Check if Docker Compose is available
if ! command -v docker compose &> /dev/null && ! docker-compose --version &> /dev/null; then
    print_error "Docker Compose is not installed. Please install Docker Compose first."
    exit 1
fi

# Detect if we need sudo for docker commands
DOCKER_CMD="docker"
if ! docker info &> /dev/null; then
    if sudo docker info &> /dev/null; then
        DOCKER_CMD="sudo docker"
        print_warning "Docker requires sudo. Consider adding your user to the docker group:"
        echo "    sudo usermod -aG docker \$USER"
        echo "    newgrp docker"
    else
        print_error "Cannot access Docker. Please check your Docker installation."
        exit 1
    fi
fi

print_step "Starting development environment setup..."

# Copy environment file if it doesn't exist
if [ ! -f .env ]; then
    print_step "Creating .env file from .env.example..."
    if [ -f .env.example ]; then
        cp .env.example .env
        print_success ".env file created"
    else
        print_warning ".env.example not found, creating basic .env file..."
        cat > .env << EOF
# Database
DATABASE_URL=postgresql://postgres:postgres@postgres:5432/entropyvn_development

# Redis
REDIS_URL=redis://redis:6379/0

# Rails
SECRET_KEY_BASE=$(bundle exec rails secret)
RAILS_ENV=development

# Vite
VITE_RUBY_HOST=0.0.0.0
EOF
        print_success ".env file created"
    fi
else
    print_success ".env file already exists"
fi

# Build Docker containers
print_step "Building Docker containers..."
$DOCKER_CMD compose build
print_success "Docker containers built"

# Start services
print_step "Starting Docker containers..."
$DOCKER_CMD compose up -d postgres redis
print_success "PostgreSQL and Redis started"

# Wait for database to be ready
print_step "Waiting for database to be ready..."
until $DOCKER_CMD compose exec -T postgres pg_isready -U postgres > /dev/null 2>&1; do
    echo -n "."
    sleep 1
done
echo ""
print_success "Database is ready"

# Install Ruby gems
print_step "Installing Ruby gems..."
$DOCKER_CMD compose run --rm --no-deps --entrypoint "bundle" rails install
print_success "Ruby gems installed"

# Install npm packages
print_step "Installing npm packages..."
$DOCKER_CMD compose run --rm --no-deps --entrypoint "npm" rails ci
print_success "npm packages installed"

# Setup database (create, migrate, seed)
print_step "Setting up database..."
$DOCKER_CMD compose run --rm --no-deps --entrypoint "bundle" rails exec rails db:create
$DOCKER_CMD compose run --rm --no-deps --entrypoint "bundle" rails exec rails db:migrate
$DOCKER_CMD compose run --rm --no-deps --entrypoint "bundle" rails exec rails db:seed
print_success "Database setup completed"

# Precompile assets (if needed)
print_step "Precompiling assets..."
$DOCKER_CMD compose run --rm --no-deps --entrypoint "bundle" rails exec rails assets:precompile || print_warning "Asset precompilation skipped"
print_success "Assets ready"

print_step "Setup completed successfully!"
echo ""
echo -e "${GREEN}Development environment is ready!${NC}"
echo ""
echo "Available commands:"
if [ "$DOCKER_CMD" = "sudo docker" ]; then
    echo "  sudo docker compose up              - Start all services"
    echo "  sudo docker compose up rails        - Start Rails server"
    echo "  sudo docker compose up vite         - Start Vite dev server"
    echo "  sudo docker compose logs -f rails   - View Rails logs"
    echo "  sudo docker compose exec rails bash - Open shell in container"
    echo "  sudo docker compose down            - Stop all services"
else
    echo "  docker compose up              - Start all services"
    echo "  docker compose up rails        - Start Rails server"
    echo "  docker compose up vite         - Start Vite dev server"
    echo "  docker compose logs -f rails   - View Rails logs"
    echo "  docker compose exec rails bash - Open shell in container"
    echo "  docker compose down            - Stop all services"
fi
echo ""
echo -e "${YELLOW}Default Admin User:${NC}"
echo "  Email: admin@example.com"
echo "  Password: Admin123!"
echo ""
echo -e "${BLUE}To start the development server, run:${NC}"
echo "  docker compose up"
echo ""
