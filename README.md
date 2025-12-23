# EntropyVN

A Ruby on Rails 8 application with PostgreSQL, Redis, and modern frontend stack (Turbo + Stimulus + Tailwind CSS).

## Requirements

- Docker & Docker Compose
- Ruby 3.4.3
- PostgreSQL 17+
- Redis 7+

## Quick Start with Docker (Recommended)

### 1. Copy environment variables

```bash
cp .env.example .env
```

Edit `.env` and add your `RAILS_MASTER_KEY` (found in `config/master.key`).

### 2. Start services

```bash
# Build and start all services
docker compose up --build

# Or run in detached mode
docker compose up --build -d
```

The application will be available at [http://localhost:3000](http://localhost:3000)

### 3. Setup database

```bash
# Create and migrate database
docker compose exec rails bin/rails db:create db:migrate

# Load seed data (optional)
docker compose exec rails bin/rails db:seed
```

## Docker Compose Commands

```bash
# Start development server
docker compose up

# Stop services
docker compose down

# View logs
docker compose logs -f rails

# Run Rails console
docker compose run --rm runner bash
# Then inside container: bundle exec rails console

# Run tests
docker compose --profile test up test --abort-on-container-exit

# Run a specific test
docker compose run --rm runner bundle exec rails test test/models/user_test.rb

# Run migrations
docker compose exec rails bin/rails db:migrate

# Reset database
docker compose exec rails bin/rails db:reset

# Install new gems
docker compose exec rails bundle install

# Run Rails generator
docker compose exec rails bin/rails generate controller Home index
```

## Local Development (without Docker)

### 1. Install dependencies

```bash
# Install Ruby gems
bundle install

# Install JavaScript packages (if needed)
yarn install
```

### 2. Setup PostgreSQL

```bash
# Create user and databases
sudo -u postgres createuser -s $(whoami)
createdb entropyvn_development
createdb entropyvn_test
```

### 3. Setup Redis

```bash
# Start Redis service
sudo systemctl start redis
# or: redis-server
```

### 4. Setup environment

```bash
cp .env.example .env
# Edit .env and add your RAILS_MASTER_KEY from config/master.key
```

### 5. Setup database

```bash
bin/rails db:create db:migrate
bin/rails db:seed  # optional
```

### 6. Start server

```bash
bin/rails server
```

Visit [http://localhost:3000](http://localhost:3000)

## Testing

```bash
# Run all tests
bin/rails test

# Run with Docker
docker compose --profile test up test --abort-on-container-exit

# Run specific test file
bin/rails test test/models/user_test.rb

# Run with verbose output
bin/rails test --verbose

# Run system tests
bin/rails test:system
```

## Code Quality

```bash
# Run RuboCop
bundle exec rubocop

# Auto-fix RuboCop issues
bundle exec rubocop -a

# Run Brakeman security scan
bundle exec brakeman

# Run bundler-audit for security vulnerabilities
bundle exec bundler-audit check --update
```

## Production Deployment

This project is configured for deployment with [Kamal](https://kamal-deploy.org).

```bash
# Setup Kamal
bundle exec kamal setup

# Deploy
bundle exec kamal deploy

# Deploy with details
kamal deploy -d
```

## Project Structure

```
.
├── app/               # Application code (models, views, controllers)
├── bin/               # Scripts (rails, bundle, etc.)
├── config/            # Application configuration
├── db/                # Database schema and migrations
├── docker-compose.yml # Docker services configuration
├── Dockerfile         # Production Docker image
├── Dockerfile.dev     # Development Docker image
├── lib/               # Library code
├── log/               # Application logs
├── public/            # Public files
├── storage/           # Active Storage files
├── test/              # Test files
└── tmp/               # Temporary files
```

## Configuration

### Database

Database configuration is in [config/database.yml](config/database.yml).

### Environment Variables

See [`.env.example`](.env.example) for all available environment variables.

## Troubleshooting

### Database connection issues

```bash
# Reset database
docker compose exec rails bin/rails db:reset

# Check PostgreSQL connection
docker compose exec postgres psql -U postgres -c "SELECT version();"
```

### Redis connection issues

```bash
# Check Redis connection
docker compose exec redis redis-cli ping
```

### Clean rebuild

```bash
# Stop and remove all containers, volumes, and images
docker compose down -v
docker compose build --no-cache
docker compose up
```

## License

This project is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
