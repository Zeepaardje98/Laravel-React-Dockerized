#!/bin/sh

# Usage: ./run_env.sh [test|prod|dev]
ENV_FOLDER="$1"

if [ -z "$ENV_FOLDER" ]; then
  echo "Usage: $0 [test|prod|dev]"
  exit 1
fi

# Build the base image if it doesn't exist or Dockerfile.base has changed
docker build -f docker/Dockerfile.base -t laravel-base:latest .

# Go to the correct docker-compose folder and run
cd "docker/$ENV_FOLDER" || { echo "Invalid environment folder: $ENV_FOLDER"; exit 1; }

# Remove the app_files volume to ensure fresh files
docker-compose down
PROJECT_NAME=$(docker-compose config --project-name 2>/dev/null || basename $(pwd))
docker volume rm "${PROJECT_NAME}_app_files" 2>/dev/null || true

docker-compose up -d --build