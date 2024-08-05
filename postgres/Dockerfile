# Postgres postgres-  ./Dockerfile
# Use the official PostgreSQL image as the base image
FROM postgres:16.3

# Install iproute2
RUN apt-get update && apt-get install -y iproute2

# Copy the initialization script when creating a new database with new image
# COPY init/init-db.sql /docker-entrypoint-initdb.d/

# Set the command to start PostgreSQL with the custom configuration
# CMD ["postgres", "-c", "config_file=/var/lib/pgsql/data/postgresql.conf"]
