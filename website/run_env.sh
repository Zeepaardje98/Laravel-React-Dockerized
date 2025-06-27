#!/bin/sh

# Usage: ./run_env.sh [test|prod|dev] [testing|integration|bindmount|volume]
ENV_FOLDER="$1"
ENV_TYPE="$2"

if [ -z "$ENV_FOLDER" ]; then
  echo "Usage: $0 [test|prod|dev] [testing|integration|bindmount|volume]"
  echo "For test environment, you can specify:"
  echo "  testing      - For running unit/feature tests"
  echo "  integration  - For running integration/browser tests with nginx"
  echo "For dev environment, you can specify:"
  echo "  bindmount   - For live reload during development"
  echo "  volume      - For isolated development environment"
  exit 1
fi

# Build the base image if it doesn't exist or Dockerfile.base has changed
docker build -f docker/Dockerfile.base -t laravel-base:latest .

# Stop all possible configurations from all environments
echo "Stopping any running containers..."
(cd docker/test && docker-compose -f docker-compose-testing.yml down 2>/dev/null || true)
(cd docker/test && docker-compose -f docker-compose-integration.yml down 2>/dev/null || true)
(cd docker/dev && docker-compose -f docker-compose-bindmount.yml down 2>/dev/null || true)
(cd docker/dev && docker-compose -f docker-compose-volume.yml down 2>/dev/null || true)
(cd docker/prod && docker-compose -f docker-compose.yml down 2>/dev/null || true)

# Go to the correct docker-compose folder
cd "docker/$ENV_FOLDER" || { echo "Invalid environment folder: $ENV_FOLDER"; exit 1; }

# Handle environment types and set env file
if [ "$ENV_FOLDER" = "test" ]; then
  if [ "$ENV_TYPE" = "testing" ]; then
    COMPOSE_FILE="docker-compose-testing.yml"
    ENV_FILE=".env.testing"
  elif [ "$ENV_TYPE" = "integration" ]; then
    COMPOSE_FILE="docker-compose-integration.yml"
    ENV_FILE=".env.integration"
  else
    # Default to testing if no type specified
    COMPOSE_FILE="docker-compose-testing.yml"
    ENV_FILE=".env.testing"
  fi
elif [ "$ENV_FOLDER" = "dev" ]; then
  if [ "$ENV_TYPE" = "bindmount" ]; then
    COMPOSE_FILE="docker-compose-bindmount.yml"
    ENV_FILE=".env.dev"
  elif [ "$ENV_TYPE" = "volume" ]; then
    COMPOSE_FILE="docker-compose-volume.yml"
    ENV_FILE=".env.dev"
  else
    # Default to bindmount for development if no type specified
    COMPOSE_FILE="docker-compose-bindmount.yml"
    ENV_FILE=".env.dev"
  fi
else
  COMPOSE_FILE="docker-compose.yml"
  ENV_FILE=".env"
fi

# Remove the app_files volume to ensure fresh files
PROJECT_NAME=$(docker-compose -f $COMPOSE_FILE config --project-name 2>/dev/null || basename $(pwd))
docker volume rm "${PROJECT_NAME}_app_files" 2>/dev/null || true

docker-compose -f $COMPOSE_FILE --env-file $ENV_FILE up -d --build