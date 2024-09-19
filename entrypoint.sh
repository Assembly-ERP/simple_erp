#!/bin/bash
set -e

echo "DB_HOST: $DB_HOST"
echo "DB_PORT: $DB_PORT"

# Function to wait for PostgreSQL
wait_for_postgres() {
  local host="$1"
  local port="$2"
  local max_attempts=20 
  local attempt=1

  until pg_isready -h "$host" -p "$port"; do
    if [ $attempt -eq $max_attempts ]; then
      echo "Postgres is unavailable - exiting after $attempt attempts."
    fi
    echo "Postgres is unavailable - sleeping ($attempt/$max_attempts)"
    attempt=$((attempt+1))
    sleep 5
  done

  echo "Postgres is up - continuing..."
}

# Wait for PostgreSQL to be available
wait_for_postgres "${DB_HOST:-postgres}" "${DB_PORT:-3010}"

# Remove any existing server.pid for Rails.
rm -f /app/tmp/pids/server.pid

# Run database migrations
bundle exec rails db:create
bundle exec rails db:migrate
bundle exec rails db:seed

# Run cron scheduler
crontab -l | { cat; echo ""; } | crontab -
crontab -r
whenever --update-crontab
whenever

# Then exec the container's main process (what's set as CMD in the Dockerfile).
exec "$@"
