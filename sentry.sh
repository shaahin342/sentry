#!/usr/bin/env bash

# This script sets up and configures Sentry on-premise using Docker containers.
# It creates a configuration file, builds the Sentry project, and runs the necessary services.

echo "Set config.yml"

# Create the config.yml file with the necessary configuration settings.
cat <<EOT > config.yml
auth.allow-registration: false
beacon.anonymous: true
mail.backend: 'smtp'
mail.from: "foo@example.com"
mail.host: "smtp.example.com"
mail.password: "somesecurepassword"
mail.port: 465
mail.use-tls: true
mail.username: "shaahin.chaichi@gmail.com"
system.admin-email: "shaahin.chaichi@gmail.com"
system.url-prefix: "https://devnull.example.com/"
EOT

echo "Build Sentry onpremise"
# Build the Sentry project using the make build command.
# make build

# Stop and remove any existing Sentry-related Docker containers.
docker container stop sentry-cron sentry-worker sentry-web sentry-postgres sentry-redis
docker container rm sentry-cron sentry-worker sentry-web sentry-postgres sentry-redis

# Run the Redis container.
docker run \
  --detach \
  --name sentry-redis \
  redis:3.2-alpine

# Run the PostgreSQL container with the specified environment variables.
docker run \
  --detach \
  --name sentry-postgres \
  --env POSTGRES_PASSWORD='sentry' \
  --env POSTGRES_USER=sentry \
  -v /opt/docker/sentry/postgres:/var/lib/postgresql/data \
  postgres:11

echo "Generate secret key"
# Generate a secret key for Sentry and store it in a variable.
docker run --rm sentry config generate-secret-key > key
SENTRY_SECRET_KEY=$(cat key)

echo "Run migrations"
# Run the Sentry migrations.
docker run \
  --rm \
  -it \
  --link sentry-redis:redis \
  --link sentry-postgres:postgres \
  --env SENTRY_SECRET_KEY=${SENTRY_SECRET_KEY} \
  -v /opt/docker/sentry/sentry:/var/lib/sentry/files \
  sentry \
  upgrade

echo "install plugins"
# Install Sentry plugins.
docker run \
  --rm \
  -it \
  --link sentry-redis:redis \
  --link sentry-postgres:postgres \
  --env SENTRY_SECRET_KEY=${SENTRY_SECRET_KEY} \
  -v /opt/docker/sentry/sentry:/var/lib/sentry/files \
  sentry \
  pip install sentry-plugins

echo "Run service WEB"
# Run the Sentry web service.
docker run \
  --detach \
  --link sentry-redis:redis \
  --link sentry-postgres:postgres \
  --env SENTRY_SECRET_KEY=${SENTRY_SECRET_KEY} \
  --name sentry-web \
  --publish 9000:9000 \
  -v /opt/docker/sentry/sentry:/var/lib/sentry/files \
  sentry \
  run web
sleep 15

echo "Run service WORKER"
# Run the Sentry worker service.
docker run \
  --detach \
  --link sentry-redis:redis \
  --link sentry-postgres:postgres \
  --env SENTRY_SECRET_KEY=${SENTRY_SECRET_KEY} \
  --name sentry-worker \
  -v /opt/docker/sentry/sentry:/var/lib/sentry/files \
  sentry \
  run worker
sleep 15

echo "Run service CRON"
# Run the Sentry cron service.
docker run \
  --detach \
  --link sentry-redis:redis \
  --link sentry-postgres:postgres \
  --env SENTRY_SECRET_KEY=${SENTRY_SECRET_KEY} \
  --name sentry-cron \
  -v /opt/docker/sentry/sentry:/var/lib/sentry/files \
  sentry \
  run cron

# echo "Set config https://github.com/getsentry/sentry/issues/12722"
# Set the Sentry version configuration.
date
sleep 60
date
docker exec sentry-web sentry config set sentry:version-configured '9.1.2'